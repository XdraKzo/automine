-- PS99 HALLOWEEN EVENT (HatchWar) LUCKY ORB FARM + OTOMATIK EGG
-- 1) Event'te degilsen otomatik girer, son area'ya (OrbAreas.ZoneN) gecer.
-- 2) Orb varsa toplar; orb yoksa breakable'larin ortasinda bekler (pet'ler kendileri kirar).
-- 3) Orb deposu (balkabagi sayaci, ornek 49.6k/54k) dolunca egg'e gidip acar,
--    depo bosalinca geri donup tekrar orb toplar.

local Ayarlar = {
    EventAdi = "HatchWar", -- instance adi (__THINGS.Instances.HatchWar)
    OtoGiris = true,     -- event'te degilsen otomatik gir
    Zone = "max",        -- "max" = en yuksek numarali area (Zone4). Istersen sayi yaz: Zone = 4
    SadeceBolge = true,  -- true: sadece secilen area'daki orb / breakable | false: haritadaki hepsi
    Yaricap = 150,       -- area parcasi kucukse (isaret ise) merkezden bu kadar stud icindekiler

    -- ORB
    Bekleme = 0.15,      -- orb ustunde en az bekleme (sn)
    OrbMaxBekleme = 0.5, -- orb kaybolmazsa en fazla bu kadar bekle, sonrakine gec

    -- DEPO / EGG
    -- orb sayaci (PlayerGui icindeki yol). Bos birakirsan otomatik aranir.
    SayacYolu = "MainLeft.Left.Currency.HalloweenOrb.Lucky Orb.Amount",
    DepoMax = 54000,     -- depo kapasitesi (ekranda 49.6k/54k -> 54000). nil = otomatik ogren
    DoluEsik = nil,      -- orb bu sayiya gelince egg'e git. nil = DepoMax (tam dolunca)
    BosEsik = 10000,     -- egg acarken orb bu sayinin altina dusunce orb toplamaya don
    HatchAdet = nil,     -- tek seferde acilacak egg sayisi (senin max'in, ornek 62). nil = oyundan okunur
    HatchAraligi = 0.6,  -- hatch istekleri arasi bekleme (sn)
    AnimasyonGec = true, -- egg acarken "Click to open!" animasyonunu otomatik tikla
    DoluSeri = 4,        -- depo neredeyse doluyken ust uste bu kadar orb toplanamazsa "dolu" say
    EggKonum = nil,      -- egg otomatik bulunamazsa: egg'in onunde dur, F9'da
                         -- print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
                         -- calistir ve cikani buraya yaz: EggKonum = Vector3.new(x, y, z)
    AutoHatchAc = true,  -- egg'e varinca oyunun auto hatch'ini ac
    EggMaxSure = 600,    -- egg'de en fazla bu kadar sn kal
    EggTakilma = 45,     -- sayac bu kadar sn hic azalmazsa (hatch olmuyor) farma don

    TaramaAraligi = 0.2, -- tur arasi bekleme (sn)
    AntiAFK = true,
}

-- eski kopyayi durdur
getgenv().OrbRunId = (rawget(getgenv(), "OrbRunId") or 0) + 1
local RunId = getgenv().OrbRunId
local function Aktif() return getgenv().OrbRunId == RunId end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

if not game:IsLoaded() then game.Loaded:Wait() end

repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local Library
pcall(function() Library = require(ReplicatedStorage:WaitForChild("Library")) end)

local Network = Library and Library.Network

-- Anti-AFK
if Ayarlar.AntiAFK then
    pcall(function()
        for _, C in ipairs(getconnections(LocalPlayer.Idled)) do C:Disable() end
    end)

    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

local function Root()
    local Char = LocalPlayer.Character
    return Char and Char:FindFirstChild("HumanoidRootPart")
end

local function Things()
    return workspace:FindFirstChild("__THINGS")
end

local function Isinlan(Pos)
    local HRP = Root()
    if not HRP then return end

    HRP.CFrame = CFrame.new(Pos)
    HRP.AssemblyLinearVelocity = Vector3.zero
end

-- RemoteFunction cagir (cevap doner): once oyunun Network modulu, olmazsa dogrudan remote
local function Iste(Ad, ...)
    local Args = table.pack(...)

    if Network and Network.Invoke then
        local Ok, Sonuc = pcall(Network.Invoke, Ad, table.unpack(Args, 1, Args.n))
        if Ok then return true, Sonuc end
    end

    local Klasor = ReplicatedStorage:FindFirstChild("Network")
    local Remote = Klasor and Klasor:FindFirstChild(Ad)

    if Remote and Remote:IsA("RemoteFunction") then
        return pcall(function() return Remote:InvokeServer(table.unpack(Args, 1, Args.n)) end)
    elseif Remote and Remote:IsA("RemoteEvent") then
        return pcall(function() Remote:FireServer(table.unpack(Args, 1, Args.n)) end)
    end

    return false, "remote yok: " .. tostring(Ad)
end

local function Gonder(Ad, ...)
    local Args = table.pack(...)

    if Network and Network.Fire and pcall(Network.Fire, Ad, table.unpack(Args, 1, Args.n)) then return true end

    local Klasor = ReplicatedStorage:FindFirstChild("Network")
    local Remote = Klasor and Klasor:FindFirstChild(Ad)

    if Remote and Remote:IsA("RemoteEvent") then
        return (pcall(function() Remote:FireServer(table.unpack(Args, 1, Args.n)) end))
    end

    return false
end

local function ObjPos(Obj)
    if Obj:IsA("Model") then
        local Ok, CF = pcall(Obj.GetPivot, Obj)
        if Ok then return CF.Position end
    end

    local Part = Obj:IsA("BasePart") and Obj or Obj:FindFirstChildWhichIsA("BasePart", true)
    return Part and Part.Position
end

----------------------------------------------------------------
-- EVENT'E GIRIS (mining script'teki yontemin aynisi)
----------------------------------------------------------------
local function EventModeli()
    local T = Things()
    local Cont = T and T:FindFirstChild("__INSTANCE_CONTAINER")
    local Active = Cont and Cont:FindFirstChild("Active")
    return Active and Active:FindFirstChild(Ayarlar.EventAdi)
end

local function EventteMi()
    local Cmds = Library and Library.InstancingCmds

    if Cmds and Cmds.GetInstanceID then
        local Ok, Id = pcall(Cmds.GetInstanceID)
        if Ok and Id == Ayarlar.EventAdi then return true end
    end

    return EventModeli() ~= nil
end

local function PadCFrame(Pad)
    if Pad:IsA("BasePart") then return Pad.CFrame end
    if Pad:IsA("Model") then return Pad:GetPivot() end

    local Part = Pad:FindFirstChildWhichIsA("BasePart", true)
    return Part and Part.CFrame
end

local function GirisPadleri()
    local T = Things()
    local Instances = T and T:FindFirstChild("Instances")
    local Model = Instances and Instances:FindFirstChild(Ayarlar.EventAdi)
    local Teleports = Model and Model:FindFirstChild("Teleports")
    local Liste = {}

    for _, Pad in ipairs(Teleports and Teleports:GetChildren() or {}) do
        local L = Pad.Name:lower()

        if L:find("enter", 1, true) and not (L:find("leave", 1, true) or L:find("exit", 1, true)) then
            local CF = PadCFrame(Pad)
            if CF then table.insert(Liste, {Pad = Pad, CFrame = CF}) end
        end
    end

    return Liste
end

local function Bekle(Sure)
    local Son = os.clock() + Sure

    repeat
        if EventteMi() then return true end
        task.wait(0.5)
    until os.clock() >= Son or not Aktif()

    return EventteMi()
end

local function EventeGir()
    local HRP = Root()
    if not HRP then return false end

    print("[Orb] event'te degilsin, " .. Ayarlar.EventAdi .. " event'ine giriliyor...")

    for Index, Entry in ipairs(GirisPadleri()) do
        if Index > 2 then break end

        print("[Orb] giris pad'i deneniyor: " .. Entry.Pad:GetFullName())
        HRP.CFrame = Entry.CFrame
        HRP.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.6)

        if not EventteMi() then
            HRP.CFrame = Entry.CFrame * CFrame.new(0, 2.5, 0)
            task.wait(0.3)
            HRP.CFrame = Entry.CFrame
        end

        if Bekle(10) then
            print("[Orb] event'e girildi (pad).")
            return true
        end
    end

    local Cmds = Library and Library.InstancingCmds

    if Cmds and Cmds.Enter then
        print("[Orb] oyunun giris fonksiyonu deneniyor...")

        pcall(function() setthreadidentity(2) end)
        local Ok, Err = pcall(Cmds.Enter, Ayarlar.EventAdi)
        pcall(function() setthreadidentity(8) end)

        if not Ok then warn("[Orb] Enter hatasi: " .. tostring(Err)) end

        if Bekle(15) then
            print("[Orb] event'e girildi (Enter).")
            return true
        end
    end

    warn("[Orb] event'e girilemedi; 5 sn sonra tekrar denenecek.")
    return false
end

----------------------------------------------------------------
-- AREA
----------------------------------------------------------------
local function AreaBul()
    local Event = EventModeli()
    local Interact = Event and Event:FindFirstChild("INTERACT")
    local Areas = Interact and Interact:FindFirstChild("OrbAreas")

    if not Areas then return nil end

    local Secilen, SecilenNo

    for _, Part in ipairs(Areas:GetChildren()) do
        local No = tonumber(Part.Name:match("(%d+)$"))

        if No and Part:IsA("BasePart") then
            if Ayarlar.Zone == "max" then
                if not SecilenNo or No > SecilenNo then Secilen, SecilenNo = Part, No end
            elseif No == tonumber(Ayarlar.Zone) then
                Secilen, SecilenNo = Part, No
            end
        end
    end

    return Secilen, SecilenNo
end

local function BolgedeMi(Area, Pos)
    if not Area or not Ayarlar.SadeceBolge then return true end

    if Area.Size.X > 20 and Area.Size.Z > 20 then
        local P = Area.CFrame:PointToObjectSpace(Pos)
        return math.abs(P.X) <= Area.Size.X / 2 + 5 and math.abs(P.Z) <= Area.Size.Z / 2 + 5
    end

    return (Pos - Area.Position).Magnitude <= Ayarlar.Yaricap
end

----------------------------------------------------------------
-- ORB DEPOSU SAYACI (ekrandaki "49.6k/54k")
----------------------------------------------------------------
local function SayiOku(Text)
    local Sayi, Ek = tostring(Text):gsub(",", ""):match("^%s*([%d%.]+)%s*(%a?)%s*$")
    Sayi = tonumber(Sayi)

    if not Sayi then return nil end

    local Carpan = ({k = 1e3, m = 1e6, b = 1e9, t = 1e12})[Ek:lower()] or (Ek == "" and 1)
    return Carpan and Sayi * Carpan
end

local SayacLabel
local SayacUyari = false

local function SayacBul()
    if SayacLabel and SayacLabel.Parent then return SayacLabel end

    local PG = LocalPlayer:FindFirstChild("PlayerGui")
    local Adaylar = {}

    -- ayardaki yol (ornek: MainLeft.Left.Currency.HalloweenOrb.Lucky Orb.Amount)
    if PG and type(Ayarlar.SayacYolu) == "string" and Ayarlar.SayacYolu ~= "" then
        local Obj = PG

        for Ad in Ayarlar.SayacYolu:gmatch("[^%.]+") do
            Obj = Obj and Obj:FindFirstChild(Ad)
        end

        if Obj and Obj:IsA("TextLabel") then
            SayacLabel = Obj
            print("[Depo] sayac (ayar): " .. Obj:GetFullName() .. " = " .. Obj.Text)
            return Obj
        end
    end

    for _, D in ipairs(PG and PG:GetDescendants() or {}) do
        if D:IsA("TextLabel") and D.Text:find("/", 1, true) then
            local A, B = D.Text:match("^%s*([%d%.,]+%s*%a?)%s*/%s*([%d%.,]+%s*%a?)%s*$")

            if A and SayiOku(A) and SayiOku(B) and SayiOku(B) > 0 then
                -- balkabagi / orb ile ilgili isimler onde
                local Yol = D:GetFullName():lower()
                local Puan = 0

                for _, K in ipairs({"orb", "pumpkin", "candy", "hatchwar", "luck", "capacity", "bag"}) do
                    if Yol:find(K, 1, true) then Puan += 1 end
                end

                table.insert(Adaylar, {Label = D, Puan = Puan})
            end
        end
    end

    table.sort(Adaylar, function(a, b) return a.Puan > b.Puan end)

    if Adaylar[1] then
        SayacLabel = Adaylar[1].Label
        print("[Depo] sayac bulundu: " .. SayacLabel:GetFullName() .. " = " .. SayacLabel.Text)

        for I = 2, math.min(#Adaylar, 4) do
            print("[Depo]   diger aday: " .. Adaylar[I].Label:GetFullName() .. " = " .. Adaylar[I].Label.Text)
        end

        return SayacLabel
    end

    if not SayacUyari then
        SayacUyari = true
        warn("[Depo] ekranda 'x/y' sayaci bulunamadi; doluluk orb toplanamamasindan anlasilacak.")
    end
end

-- sayac bazen "49.6k/600" gibi mantiksiz max gosteriyor: o zaman max'i
-- orb'lar toplanamaz hale geldigi andaki degerden ogreniriz
local OgrenilenMax

-- doner: mevcut, max (okunamazsa nil)
local function Depo()
    local Label = SayacBul()
    if not Label then return nil end

    local A, B = Label.Text:match("^%s*([%d%.,]+%s*%a?)%s*/%s*([%d%.,]+%s*%a?)%s*$")
    local Su, Max = SayiOku(A or ""), SayiOku(B or "")

    if not Su then Su = SayiOku(Label.Text) end
    if not Su then return nil end

    if tonumber(Ayarlar.DepoMax) then
        Max = tonumber(Ayarlar.DepoMax)
    elseif not Max or Max < Su then
        Max = OgrenilenMax
    end

    if Max and Max > 0 then return Su, Max end
    return Su, nil
end

local function DoluEsik(Max)
    return tonumber(Ayarlar.DoluEsik) or (Max and Max * 0.995)
end

local function DepoDoluMu()
    local Su, Max = Depo()
    local Esik = DoluEsik(Max)
    return Su ~= nil and Esik ~= nil and Su >= Esik
end

----------------------------------------------------------------
-- ORB
----------------------------------------------------------------
local function OrbParcasi(Model)
    local Part = Model:FindFirstChild("Orb")
    if Part and Part:IsA("BasePart") then return Part end
    return Model:FindFirstChildWhichIsA("BasePart", true)
end

local function Orblar(Area)
    local Debris = workspace:FindFirstChild("__DEBRIS")
    local Klasor = Debris and Debris:FindFirstChild("HatchWarOrbs")
    local Liste = {}

    for _, Model in ipairs(Klasor and Klasor:GetChildren() or {}) do
        if Model.Name:find("Orb") then
            local Part = OrbParcasi(Model)

            if Part and BolgedeMi(Area, Part.Position) then
                table.insert(Liste, {Model = Model, Part = Part})
            end
        end
    end

    return Liste
end

local ToplamOrb = 0
local BasarisizSeri = 0

-- doner: true = depo doldu (egg'e gidilmeli)
local function OrblariTopla(Liste)
    local HRP = Root()
    if not HRP then return false end

    local Pos = HRP.Position

    while #Liste > 0 and Aktif() do
        if DepoDoluMu() then return true end

        local En, EnI

        for I, Orb in ipairs(Liste) do
            local D = (Orb.Part.Position - Pos).Magnitude
            if not En or D < En then En, EnI = D, I end
        end

        local Orb = table.remove(Liste, EnI)
        HRP = Root()
        if not HRP then return false end

        if Orb.Model.Parent and Orb.Part.Parent then
            Pos = Orb.Part.Position
            Isinlan(Pos + Vector3.new(0, 2, 0))

            if firetouchinterest then
                pcall(function()
                    firetouchinterest(HRP, Orb.Part, 0)
                    firetouchinterest(HRP, Orb.Part, 1)
                end)
            end

            task.wait(Ayarlar.Bekleme)

            local Son = os.clock() + Ayarlar.OrbMaxBekleme
            while Orb.Model.Parent and os.clock() < Son do task.wait(0.03) end

            if not Orb.Model.Parent then
                BasarisizSeri = 0
                ToplamOrb += 1
                if ToplamOrb % 25 == 0 then print(("[Orb] toplanan orb: %d"):format(ToplamOrb)) end
            else
                -- ustunde durdugumuz halde toplanmadi: depo dolu olabilir
                -- (sayac depo bos diyorsa sayma: orb baska sebepten toplanmamistir)
                local Su, Max = Depo()
                local NeredeyseDolu = not (Su and Max) or Su >= Max * 0.8

                BasarisizSeri = NeredeyseDolu and BasarisizSeri + 1 or 0

                if BasarisizSeri >= Ayarlar.DoluSeri then
                    BasarisizSeri = 0

                    -- depo kapasitesini ogren (sayacin max'i guvenilmez)
                    local Su = Depo()
                    if Su and Su > 0 and not tonumber(Ayarlar.DepoMax) then
                        OgrenilenMax = math.max(OgrenilenMax or 0, Su)
                    end

                    print(("[Depo] ust uste orb toplanamadi -> depo dolu sayiliyor (sayac %s)."):format(
                        SayacLabel and SayacLabel.Text or "?"))
                    return true
                end
            end
        end
    end

    return false
end

----------------------------------------------------------------
-- BREAKABLE: sadece ortalarinda dur, pet'ler kendi kirar
----------------------------------------------------------------
local function BreakableMerkezi(Area)
    local T = Things()
    local Klasor = T and T:FindFirstChild("Breakables")
    local Toplam, Sayi = Vector3.zero, 0

    for _, B in ipairs(Klasor and Klasor:GetChildren() or {}) do
        local Pos = ObjPos(B)

        if Pos and BolgedeMi(Area, Pos) then
            Toplam += Pos
            Sayi += 1
        end
    end

    if Sayi > 0 then return Toplam / Sayi, Sayi end
end

----------------------------------------------------------------
-- EGG
----------------------------------------------------------------
local EggUyari = false

-- event icindeki en yakin egg (secilen area'ya en yakin olani)
local function EggBul(Area)
    if typeof(Ayarlar.EggKonum) == "Vector3" then return Ayarlar.EggKonum, "EggKonum ayari" end

    local Merkez = Area and Area.Position or (Root() and Root().Position)
    local Adaylar = {}

    local function Ekle(Obj)
        local Pos = ObjPos(Obj)
        if Pos then table.insert(Adaylar, {Obj = Obj, Pos = Pos}) end
    end

    -- event egg'leri __THINGS.CustomEggs icinde, isimleri uid (ornek 7527e336fea5...).
    -- (event modelindeki "EggPlat" gibi parcalar egg degil, onlara bakma)
    local T = Things()
    local Klasor = T and T:FindFirstChild("CustomEggs")

    for _, E in ipairs(Klasor and Klasor:GetChildren() or {}) do Ekle(E) end

    if #Adaylar == 0 or not Merkez then
        if not EggUyari then
            EggUyari = true
            warn("[Egg] egg bulunamadi. Ayarlar.EggKonum'a egg'in konumunu yaz.")
        end

        return nil
    end

    table.sort(Adaylar, function(a, b) return (a.Pos - Merkez).Magnitude < (b.Pos - Merkez).Magnitude end)

    return Adaylar[1].Pos, Adaylar[1].Obj:GetFullName(), Adaylar[1].Obj
end

local ToplamEgg = 0

-- calisan hatch adedi (bulununca hatirlanir)
local CalisanAdet
local MaxArandi = false
local AdetListesi = {}
for N = 120, 1, -1 do table.insert(AdetListesi, N) end -- 120'den asagi tek tek
local AdetIndex = 1
local HatchLog = 0

local function SiradakiAdet()
    if Ayarlar.HatchAdet then return Ayarlar.HatchAdet end
    if CalisanAdet then return CalisanAdet end

    -- oyunun kendi max hatch degeri: Library icinde adinda "maxhatch" gecen fonksiyonu ara (bir kez)
    if not MaxArandi then
        MaxArandi = true

        for ModulAdi, Modul in pairs(Library or {}) do
            if type(Modul) == "table" then
                for FnAdi, Fn in pairs(Modul) do
                    if type(Fn) == "function" and tostring(FnAdi):lower():find("maxhatch", 1, true) then
                        for _, Arg in ipairs({{}, {LocalPlayer}}) do
                            local Ok, Max = pcall(Fn, table.unpack(Arg))

                            if Ok and tonumber(Max) and tonumber(Max) > 0 then
                                CalisanAdet = tonumber(Max)
                                print(("[Egg] max hatch: %d (%s.%s)"):format(CalisanAdet, tostring(ModulAdi), tostring(FnAdi)))
                                return CalisanAdet
                            end
                        end
                    end
                end
            end
        end

        warn("[Egg] oyunun max hatch degeri bulunamadi; deneyerek bulunacak. Bilirsen Ayarlar.HatchAdet'e yaz.")
    end

    return AdetListesi[AdetIndex] or 1
end

-- tek hatch istegi. doner: basarili mi
local function HatchGonder(EggObj)
    local Uid = EggObj and EggObj.Name
    if not Uid then return false end

    local Adet = SiradakiAdet()
    local Ok, Sonuc = Iste("CustomEggs_Hatch", Uid, Adet)
    local Basarili = Ok and Sonuc ~= false and Sonuc ~= nil

    if HatchLog < 6 then
        HatchLog += 1
        print(("[Egg] CustomEggs_Hatch(%s, %d) -> ok=%s sonuc=%s"):format(Uid, Adet, tostring(Ok), tostring(Sonuc)))
    end

    if Basarili then
        if not CalisanAdet then
            CalisanAdet = Adet
            print(("[Egg] hatch calisiyor: tek seferde %d egg."):format(Adet))
        end
    elseif not CalisanAdet and not Ayarlar.HatchAdet then
        -- bu adet reddedildi: daha kucugunu dene
        AdetIndex = math.min(AdetIndex + 1, #AdetListesi)
    end

    return Basarili
end

local function EggAc(Area)
    local EggPos, Ad, EggObj = EggBul(Area)

    if not EggPos then
        task.wait(5)
        return
    end

    -- egg'in onunde dur (area tarafina dogru 7 stud)
    local Yon = Area and (Area.Position - EggPos) * Vector3.new(1, 0, 1) or Vector3.new(0, 0, 1)
    Yon = Yon.Magnitude > 0.1 and Yon.Unit or Vector3.new(0, 0, 1)
    local Durak = EggPos + Yon * 7 + Vector3.new(0, 3, 0)

    print(("[Egg] depo dolu -> egg'e gidiliyor: %s"):format(tostring(Ad)))
    Isinlan(Durak)
    task.wait(0.5)

    if Ayarlar.AutoHatchAc then Gonder("AutoHatch_Enable") end

    local Basla = os.clock()
    local SonDegisim = os.clock()
    local OncekiSu = Depo()

    while Aktif() and os.clock() - Basla < Ayarlar.EggMaxSure do
        if Ayarlar.OtoGiris and not EventteMi() then return end

        -- egg'den uzaklastiysak geri don
        local HRP = Root()
        if HRP and (HRP.Position - Durak).Magnitude > 8 then Isinlan(Durak) end

        -- egg'i ac (auto hatch calismasa bile)
        if EggObj and EggObj.Parent then HatchGonder(EggObj) end

        -- "Click to open!" animasyonunu gec
        if Ayarlar.AnimasyonGec then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
            end)
        end

        local Su, Max = Depo()

        if Su then
            if Su < (tonumber(Ayarlar.BosEsik) or 10000) then
                ToplamEgg += 1
                print(("[Egg] depo bosaldi (%s) -> orb farmina donuluyor. (tur %d)"):format(SayacLabel and SayacLabel.Text or "?", ToplamEgg))
                return
            end

            if OncekiSu and Su < OncekiSu then SonDegisim = os.clock() end
            OncekiSu = Su

            if os.clock() - SonDegisim > Ayarlar.EggTakilma then
                warn(("[Egg] %d sn'dir sayac azalmadi (hatch olmuyor?). Farma donuluyor."):format(Ayarlar.EggTakilma))
                return
            end
        elseif os.clock() - Basla > 30 then
            -- sayac okunamiyor: 30 sn hatch edip geri don
            return
        end

        -- max adet henuz bulunmadiysa hizli dene
        task.wait((CalisanAdet or Ayarlar.HatchAdet) and Ayarlar.HatchAraligi or 0.15)
    end
end

----------------------------------------------------------------
-- ANA DONGU
----------------------------------------------------------------
local AreaUyari = false
local SonArea

print("[Orb] lucky orb farm + otomatik egg basladi.")
SayacBul()

while Aktif() do
    local HRP = Root()

    if not HRP then
        task.wait(1)
        continue
    end

    if Ayarlar.OtoGiris and not EventteMi() then
        SonArea = nil
        if not EventeGir() then task.wait(5) end
        continue
    end

    local Area, AreaNo = AreaBul()

    if Area then
        AreaUyari = false

        if SonArea ~= Area then
            SonArea = Area
            print(("[Orb] hedef area: Zone%d (%s) boyut=%s"):format(AreaNo, Area:GetFullName(), tostring(Area.Size)))
        end
    elseif not AreaUyari then
        AreaUyari = true
        warn("[Orb] OrbAreas bulunamadi. Tum orb'lar hedeflenecek.")
    end

    -- depo dolu: egg ac
    if DepoDoluMu() then
        EggAc(Area)
        continue
    end

    local Orbs = Orblar(Area)

    if #Orbs > 0 then
        if OrblariTopla(Orbs) then
            EggAc(Area)
        end
    else
        -- orb yok: breakable'larin ortasinda bekle, pet'ler kirsin
        local Merkez = BreakableMerkezi(Area) or (Area and Area.Position)

        if Merkez and (HRP.Position - Merkez).Magnitude > 12 then
            Isinlan(Merkez + Vector3.new(0, 4, 0))
        end
    end

    task.wait(Ayarlar.TaramaAraligi)
end

print(("[Orb] durduruldu. Orb: %d | egg turu: %d"):format(ToplamOrb, ToplamEgg))
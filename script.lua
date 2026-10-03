-- PS99 HALLOWEEN EVENT (HatchWar) LUCKY ORB FARM + BOSS FIGHT / EGG
-- 1) Event'te degilsen otomatik girer, son area'ya (OrbAreas.ZoneN) gecer.
-- 2) Orb varsa toplar; orb yoksa breakable'larin ortasinda bekler (pet'ler kendileri kirar).
-- 3) Orb deposu dolunca boss fight atar (ekrana hizli tiklar, baloncuklara basar).
--    DoluIslem = "egg" yaparsan boss yerine egg acar.

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
    DepoMax = nil,       -- depo kapasitesi. nil = sayactan okunur (ornek 29.7k/67.5k -> 67500); kapasite artinca kendisi guncellenir
    DoluEsik = nil,      -- orb bu sayiya gelince egg'e git. nil = DepoMax (tam dolunca)
    BosEsik = 10000,     -- (sadece egg modu) egg acarken orb bu sayinin altina dusunce orb toplamaya don
    HatchAdet = 62,      -- tek seferde acilacak egg sayisi (her egg 100 orb: 62 egg = 6.2k). nil = deneyerek bulunur
    HatchAraligi = 0.1,  -- hatch istekleri arasi bekleme (sn)
    AnimasyonGec = true, -- egg acarken "Click to open!" animasyonunu otomatik tikla
    DoluSeri = 4,        -- depo neredeyse doluyken ust uste bu kadar orb toplanamazsa "dolu" say
    EggKonum = nil,      -- egg otomatik bulunamazsa: egg'in onunde dur, F9'da
                         -- print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
                         -- calistir ve cikani buraya yaz: EggKonum = Vector3.new(x, y, z)
    AutoHatchAc = true,  -- egg'e varinca oyunun auto hatch'ini ac
    EggMaxSure = 600,    -- egg'de en fazla bu kadar sn kal
    EggTakilma = 45,     -- sayac bu kadar sn hic azalmazsa (hatch olmuyor) farma don

    -- DOLUNCA NE YAPILSIN: "boss" = boss fight, "egg" = egg ac
    DoluIslem = "egg",

    -- BOSS FIGHT
    BossZone = 4,        -- hangi area'nin boss'u (4 = Warlock Ahmad). "max" = en yuksek
    TiklamaAraligi = 0.03, -- fight sirasinda ekrana tiklama araligi (sn)
    FightMaxSure = 180,  -- bir fight en fazla bu kadar sn surer, sonra birakilir
    FightArasi = 3,      -- iki fight arasi bekleme (sn)

    -- COIN FLAG: son area'da flag dik (FlexibleFlags_Consume)
    OtoFlag = true,
    FlagAdi = "Coins Flag", -- envanterdeki flag'in adi (ornek: "Coins Flag", "Diamonds Flag", "Magnet Flag")
    FlagAraligi = 60,    -- iki flag dikme arasi en az bekleme (sn). Area'da flag gorunuyorsa hic dikilmez

    -- COIN ILE EGG: event coin'i cok birikince (orb'dan bagimsiz) egg ac
    CoinEgg = true,
    CoinId = "HatchWarCoins", -- egg'in parasi
    CoinUst = 1e9,       -- coin bu kadar olunca egg acmaya git (1e9 = 1b)
    CoinAlt = 2e8,       -- coin bu kadara dusunce egg'i birak (2e8 = 200m)

    -- OTOMATIK UPGRADE (asa/wand parasiyla)
    OtoUpgrade = true,
    -- oncelik sirasi (ID'ler). Listede olmayan upgrade'lere hic dokunulmaz.
    UpgradeOncelik = {"HatchWarOrbPower", "HatchWarOrbBank", "HatchWarOrbSpawn"},
    -- "sirali"  = ilk upgrade max olana kadar sadece onu al (para ona saklanir), sonra siradakine gec
    -- "yettikce" = listeyi sirayla dene, parasi yeten ilkini al
    UpgradeMod = "sirali",
    UpgradeAraligi = 90, -- kac sn'de bir upgrade noktasina gidilsin
    -- upgrade noktasi otomatik bulunamazsa: noktada dur, F9'da
    -- print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position) calistir, cikani yaz:
    UpgradeKonum = nil,  -- ornek: Vector3.new(100, 20, -300)

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
local GuiService = game:GetService("GuiService")
local VIM = game:GetService("VirtualInputManager")
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
    elseif Max and Max >= Su and Max >= 5000 then
        -- event icinde sayac dogru kapasiteyi gosterir (ornek 67.5k); hatirla
        OgrenilenMax = Max
    else
        -- event disinda "30.8k/750" gibi baska bir sey gosterebiliyor: son bilinen kapasiteyi kullan
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

-- kayit verisi (Library.Save bu oyunda bos olabiliyor, Client.Save'den okunur)
local SaveModul

local function SaveGet()
    if not SaveModul then
        pcall(function() SaveModul = require(ReplicatedStorage.Library.Client.Save) end)
        if not SaveModul and Library and type(Library.Save) == "table" then SaveModul = Library.Save end
    end

    local Ok, Save = pcall(function() return SaveModul.Get() end)
    return Ok and type(Save) == "table" and Save or nil
end

-- envanterde id'si verilen esya: toplam adet, uid
local function EnvanterBul(Id)
    local Save = SaveGet()
    local Toplam, Uid = 0, nil

    for Kategori, Esyalar in pairs(Save and Save.Inventory or {}) do
        -- pet kategorisi binlerce kayit olabilir, atla (aranan seyler Currency / Misc'te)
        if type(Esyalar) == "table" and not tostring(Kategori):lower():find("pet") then
            for U, E in pairs(Esyalar) do
                if type(E) == "table" and E.id == Id then
                    Toplam += tonumber(E._am) or 1
                    Uid = Uid or U
                end
            end
        end
    end

    return Toplam, Uid
end

local function KisaSayi(N)
    if N >= 1e9 then return ("%.2fb"):format(N / 1e9) end
    if N >= 1e6 then return ("%.1fm"):format(N / 1e6) end
    if N >= 1e3 then return ("%.1fk"):format(N / 1e3) end
    return tostring(math.floor(N))
end

local CoinOnbellek, CoinZaman = 0, -math.huge
local CoinUyari, CoinYazildi = false, false

local function CoinOku()
    -- ana dongu cok sik soruyor: 2 sn onbellek
    if os.clock() - CoinZaman < 2 then return CoinOnbellek end

    CoinOnbellek, CoinZaman = EnvanterBul(Ayarlar.CoinId), os.clock()

    if CoinOnbellek == 0 and not CoinUyari then
        CoinUyari = true
        warn("[Egg] envanterde '" .. tostring(Ayarlar.CoinId) .. "' okunamadi (0). Coin ile egg acma calismayabilir.")
    elseif CoinOnbellek > 0 and not CoinYazildi then
        CoinYazildi = true
        print(("[Egg] coin: %s (egg acma %s'de baslar, %s'de durur)"):format(
            KisaSayi(CoinOnbellek), KisaSayi(Ayarlar.CoinUst), KisaSayi(Ayarlar.CoinAlt)))
    end

    return CoinOnbellek
end

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

-- Mod = "coin": coin CoinAlt'a dusene kadar ac (orb'a bakilmaz). Yoksa orb BosEsik'e dusene kadar.
local function EggAc(Area, Mod)
    local EggPos, Ad, EggObj = EggBul(Area)

    if not EggPos then
        task.wait(5)
        return
    end

    -- egg'in onunde dur (area tarafina dogru 7 stud)
    local Yon = Area and (Area.Position - EggPos) * Vector3.new(1, 0, 1) or Vector3.new(0, 0, 1)
    Yon = Yon.Magnitude > 0.1 and Yon.Unit or Vector3.new(0, 0, 1)
    local Durak = EggPos + Yon * 7 + Vector3.new(0, 3, 0)

    if Mod == "coin" then
        print(("[Egg] coin %s -> %s'e inene kadar egg aciliyor: %s"):format(
            KisaSayi(CoinOku()), KisaSayi(Ayarlar.CoinAlt), tostring(Ad)))
    else
        print(("[Egg] depo dolu -> egg'e gidiliyor: %s"):format(tostring(Ad)))
    end

    Isinlan(Durak)
    task.wait(0.5)

    if Ayarlar.AutoHatchAc then Gonder("AutoHatch_Enable") end

    local Basla = os.clock()
    local SonDegisim = os.clock()
    local OncekiSu = Mod == "coin" and CoinOku() or Depo()

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

        if Mod == "coin" then
            local Coin = CoinOku()

            if Coin <= Ayarlar.CoinAlt then
                ToplamEgg += 1
                print(("[Egg] coin %s'e dustu -> farma donuluyor."):format(KisaSayi(Coin)))
                return
            end

            if OncekiSu and Coin < OncekiSu then SonDegisim = os.clock() end
            OncekiSu = Coin

            if os.clock() - SonDegisim > Ayarlar.EggTakilma then
                warn(("[Egg] %d sn'dir coin azalmadi (hatch olmuyor?). Farma donuluyor."):format(Ayarlar.EggTakilma))
                return
            end

            task.wait((CalisanAdet or Ayarlar.HatchAdet) and Ayarlar.HatchAraligi or 0.15)
            continue
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
-- BOSS FIGHT
-- Boss: __INSTANCE_CONTAINER.Active.HatchWar.INTERACT.Bosses.BossN
-- Baslatma: boss'un yaninda E (PlayerGui.Interact.Button)
-- Fight sirasinda karakterde HW_BossHoldPosition olur; ekrana hizli tiklanir,
-- cikan baloncuklar PlayerGui._INSTANCES.HatchWarBoss.LiveCircle (ImageButton)
----------------------------------------------------------------
local function PG()
    return LocalPlayer:FindFirstChild("PlayerGui")
end

local function GuiGorunur(Obj)
    local Cur = Obj

    while Cur and Cur ~= game do
        if Cur:IsA("GuiObject") and not Cur.Visible then return false end
        if Cur:IsA("ScreenGui") and not Cur.Enabled then return false end
        Cur = Cur.Parent
    end

    return true
end

-- butonun baglantilarini dogrudan tetikle
local function ButonaBas(Btn)
    local Basti = false

    pcall(function()
        for _, Sinyal in ipairs({Btn.MouseButton1Down, Btn.MouseButton1Click, Btn.Activated}) do
            for _, C in ipairs(getconnections(Sinyal)) do
                pcall(function() C:Fire() end)
                Basti = true
            end
        end
    end)

    return Basti
end

local function EkranaTikla(X, Y)
    pcall(function()
        VIM:SendMouseButtonEvent(X, Y, 0, true, game, 1)
        VIM:SendMouseButtonEvent(X, Y, 0, false, game, 1)
    end)
end

local function GuiMerkez(Btn)
    local P = Btn.AbsolutePosition + Btn.AbsoluteSize / 2
    local Gui = Btn:FindFirstAncestorWhichIsA("ScreenGui")
    local Inset = Vector2.zero

    if Gui and not Gui.IgnoreGuiInset then
        Inset = GuiService:GetGuiInset()
    end

    return P.X + Inset.X, P.Y + Inset.Y
end

local function BossModeli()
    local Event = EventModeli()
    local Interact = Event and Event:FindFirstChild("INTERACT")
    local Bosses = Interact and Interact:FindFirstChild("Bosses")

    if not Bosses then return nil end

    if Ayarlar.BossZone == "max" then
        local En, EnNo

        for _, B in ipairs(Bosses:GetChildren()) do
            local No = tonumber(B.Name:match("(%d+)$"))
            if No and (not EnNo or No > EnNo) then En, EnNo = B, No end
        end

        return En
    end

    return Bosses:FindFirstChild("Boss" .. tostring(Ayarlar.BossZone))
end

local function BossPos(Boss)
    local Rig = Boss:FindFirstChild("BossRig")
    local Part = Rig and (Rig:FindFirstChild("HumanoidRootPart") or Rig:FindFirstChild("Head"))

    if Part and Part:IsA("BasePart") then return Part.Position end

    return ObjPos(Boss)
end

local function FightAktif()
    local HRP = Root()
    return HRP ~= nil and HRP:FindFirstChild("HW_BossHoldPosition") ~= nil
end

-- boss'un yaninda E'ye bas (oyunun Interact butonu + klavye + varsa ProximityPrompt)
local function EBas(Boss)
    local G = PG()
    local Interact = G and G:FindFirstChild("Interact")
    local Btn = Interact and Interact:FindFirstChild("Button")

    if Btn and Btn:IsA("GuiButton") and GuiGorunur(Btn) then
        ButonaBas(Btn)
    end

    pcall(function()
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)

    if fireproximityprompt then
        for _, D in ipairs(Boss:GetDescendants()) do
            if D:IsA("ProximityPrompt") then pcall(fireproximityprompt, D) end
        end
    end
end

-- ekrandaki baloncuklara bas. doner: kac baloncuga basildi
local BaloncukGoruldu = setmetatable({}, {__mode = "k"})
local BaloncukLog = 0
local BossGuiUyari = false

local function SinyalSay(Btn, Ad)
    local Ok, Liste = pcall(function() return getconnections(Btn[Ad]) end)
    return Ok and #Liste or -1
end

local function BaloncuklaraBas()
    local G = PG()
    local Inst = G and G:FindFirstChild("_INSTANCES")
    local Boss = Inst and Inst:FindFirstChild("HatchWarBoss")

    if not Boss then
        if not BossGuiUyari then
            BossGuiUyari = true
            local Adlar = {}
            for _, C in ipairs(Inst and Inst:GetChildren() or {}) do table.insert(Adlar, C.Name) end
            warn("[Baloncuk] _INSTANCES.HatchWarBoss yok. _INSTANCES icinde: " .. table.concat(Adlar, ", "))
        end
        return 0
    end

    local Sayi = 0

    for _, D in ipairs(Boss:GetDescendants()) do
        if D:IsA("GuiButton") and D.Name == "LiveCircle" and D.Visible and D.AbsoluteSize.X > 0 then
            local X, Y = GuiMerkez(D)
            local Ham = D.AbsolutePosition + D.AbsoluteSize / 2

            -- tani: ilk 3 baloncugun ozellikleri
            if not BaloncukGoruldu[D] then
                BaloncukGoruldu[D] = true

                if BaloncukLog < 3 then
                    BaloncukLog += 1
                    local Ekran = D:FindFirstAncestorWhichIsA("ScreenGui")
                    print(("[Baloncuk] #%d %s | konum=%.0f,%.0f boyut=%.0f,%.0f | IgnoreGuiInset=%s | baglanti: Down=%d Click=%d Activated=%d InputBegan=%d"):format(
                        BaloncukLog, D:GetFullName(), Ham.X, Ham.Y, D.AbsoluteSize.X, D.AbsoluteSize.Y,
                        tostring(Ekran and Ekran.IgnoreGuiInset), SinyalSay(D, "MouseButton1Down"),
                        SinyalSay(D, "MouseButton1Click"), SinyalSay(D, "Activated"), SinyalSay(D, "InputBegan")))

                    task.delay(0.6, function()
                        print(("[Baloncuk] #%d tiklandiktan sonra: %s"):format(BaloncukLog,
                            (D.Parent and D.Visible) and "HALA DURUYOR (tik islemedi)" or "kayboldu (tik islendi)"))
                    end)
                end
            end

            -- 1) butonun baglantilarini tetikle
            ButonaBas(D)

            -- 2) fareyi ustune goturup tikla (inset'li ve inset'siz)
            pcall(function()
                VIM:SendMouseMoveEvent(X, Y, game)
                VIM:SendMouseButtonEvent(X, Y, 0, true, game, 1)
                VIM:SendMouseButtonEvent(X, Y, 0, false, game, 1)

                if X ~= Ham.X or Y ~= Ham.Y then
                    VIM:SendMouseMoveEvent(Ham.X, Ham.Y, game)
                    VIM:SendMouseButtonEvent(Ham.X, Ham.Y, 0, true, game, 1)
                    VIM:SendMouseButtonEvent(Ham.X, Ham.Y, 0, false, game, 1)
                end
            end)

            -- 3) VirtualUser ile tikla
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(Ham.X, Ham.Y))
            end)

            Sayi += 1
        end
    end

    return Sayi
end

local BossUyari = false
local ToplamFight = 0

local function BossFight(Area)
    local Boss = BossModeli()

    if not Boss then
        if not BossUyari then
            BossUyari = true
            warn("[Boss] boss bulunamadi (INTERACT.Bosses.Boss" .. tostring(Ayarlar.BossZone) .. ").")
        end

        task.wait(5)
        return
    end

    local Pos = BossPos(Boss)
    if not Pos then task.wait(5) return end

    -- boss'un onunde dur (area tarafina dogru 8 stud)
    local Yon = Area and (Area.Position - Pos) * Vector3.new(1, 0, 1) or Vector3.new(0, 0, 1)
    Yon = Yon.Magnitude > 0.1 and Yon.Unit or Vector3.new(0, 0, 1)
    local Durak = Pos + Yon * 8 + Vector3.new(0, 3, 0)

    print(("[Boss] depo dolu -> boss fight: %s"):format(Boss.Name))

    -- fight'i baslat (3 deneme)
    for Deneme = 1, 3 do
        if FightAktif() then break end

        Isinlan(Durak)
        task.wait(0.6)
        EBas(Boss)

        local Son = os.clock() + 6
        repeat task.wait(0.2) until FightAktif() or os.clock() > Son or not Aktif()

        if not FightAktif() then
            warn(("[Boss] fight baslamadi (deneme %d/3)"):format(Deneme))
        end
    end

    if not FightAktif() then
        warn("[Boss] fight baslatilamadi; biraz sonra tekrar denenecek.")
        task.wait(Ayarlar.FightArasi)
        return
    end

    ToplamFight += 1
    print(("[Boss] fight basladi (#%d)."):format(ToplamFight))

    local Basla = os.clock()
    local Baloncuk = 0
    local Kamera = workspace.CurrentCamera
    local DokumZamani = {4, 7}

    while FightAktif() and Aktif() and os.clock() - Basla < Ayarlar.FightMaxSure do
        -- tani (ilk 2 fight): fight ekranindaki GUI'leri yaz, baloncugun gercek adini/yerini gormek icin
        if ToplamFight <= 2 and DokumZamani[1] and os.clock() - Basla >= DokumZamani[1] then
            table.remove(DokumZamani, 1)

            local G = PG()
            local Inst = G and G:FindFirstChild("_INSTANCES")
            local Satir = 0

            print(("[Dokum] fight %d, %.0f. sn ---- _INSTANCES: %s"):format(ToplamFight, os.clock() - Basla,
                Inst and #Inst:GetChildren() .. " oge" or "YOK"))

            for _, Kok in ipairs(Inst and Inst:GetChildren() or {}) do
                if Kok.Name:lower():find("boss") or Kok.Name:lower():find("hatchwar") then
                    for _, D in ipairs(Kok:GetDescendants()) do
                        if D:IsA("GuiObject") and Satir < 40 then
                            Satir += 1
                            print(("[Dokum]   %s (%s) gorunur=%s boyut=%.0fx%.0f"):format(
                                D:GetFullName():gsub("^.-_INSTANCES%.", ""), D.ClassName, tostring(GuiGorunur(D)),
                                D.AbsoluteSize.X, D.AbsoluteSize.Y))
                        end
                    end
                end
            end
        end

        -- ekrana hizli tikla (ortaya)
        local Boyut = Kamera and Kamera.ViewportSize or Vector2.new(800, 600)
        EkranaTikla(Boyut.X / 2, Boyut.Y / 2)

        -- baloncuk cikarsa hemen bas
        Baloncuk += BaloncuklaraBas()

        task.wait(Ayarlar.TiklamaAraligi)
    end

    print(("[Boss] fight bitti (%.0f sn, %d baloncuga basildi)."):format(os.clock() - Basla, Baloncuk))
    task.wait(Ayarlar.FightArasi)
end

----------------------------------------------------------------
-- COIN FLAG: area'da flag yoksa envanterden dik (FlexibleFlags_Consume(flagAdi, uid))
----------------------------------------------------------------
local SonFlag = 0
local FlagUyari = false
local FlagLog = 0

-- area'da (secilen flag turunde) flag var mi? __THINGS.Flags icine bakilir
local function AreadaFlagVar(Area)
    local T = Things()
    local Klasor = T and T:FindFirstChild("Flags")
    local Tur = Ayarlar.FlagAdi:lower():gsub("%s*flag", "") -- "coins"

    for _, F in ipairs(Klasor and Klasor:GetChildren() or {}) do
        local Pos = ObjPos(F)

        if Pos and BolgedeMi(Area, Pos) then
            local Metin = F.Name:lower()

            for K, V in pairs(F:GetAttributes()) do Metin ..= " " .. tostring(K):lower() .. "=" .. tostring(V):lower() end
            for _, D in ipairs(F:GetDescendants()) do Metin ..= " " .. D.Name:lower() end

            if Metin:find(Tur, 1, true) then return true, F end
        end
    end

    return false
end

local function FlagKontrol(Area)
    if not Ayarlar.OtoFlag or not Area then return end
    if os.clock() - SonFlag < Ayarlar.FlagAraligi then return end

    if AreadaFlagVar(Area) then
        SonFlag = os.clock()
        return
    end

    local Adet, Uid = EnvanterBul(Ayarlar.FlagAdi)

    if not Uid or Adet <= 0 then
        if not FlagUyari then
            FlagUyari = true
            warn("[Flag] envanterde '" .. Ayarlar.FlagAdi .. "' yok; flag dikilmeyecek.")
        end
        return
    end

    SonFlag = os.clock()

    -- area'nin ortasinda dur ve dik
    local Merkez = BreakableMerkezi(Area) or Area.Position
    Isinlan(Merkez + Vector3.new(0, 4, 0))
    task.wait(0.4)

    local Ok, Sonuc = Iste("FlexibleFlags_Consume", Ayarlar.FlagAdi, Uid)

    FlagLog += 1
    if FlagLog <= 5 or not (Ok and Sonuc) then
        print(("[Flag] %s dikildi -> ok=%s sonuc=%s (kalan %d)"):format(Ayarlar.FlagAdi, tostring(Ok), tostring(Sonuc), Adet - 1))
    end

    -- tani: ilk dikiste Flags klasorunde ne olustugunu yaz
    if FlagLog == 1 then
        task.delay(2, function()
            local Var, F = AreadaFlagVar(Area)
            local T = Things()
            local Klasor = T and T:FindFirstChild("Flags")
            local Adlar = {}
            for _, C in ipairs(Klasor and Klasor:GetChildren() or {}) do table.insert(Adlar, C.Name) end
            print(("[Flag] Flags klasoru: %s | area'da %s flag'i gorunuyor: %s"):format(
                table.concat(Adlar, ", "), Ayarlar.FlagAdi, Var and F:GetFullName() or "HAYIR (her " .. Ayarlar.FlagAraligi .. " sn'de bir dikilecek)"))
        end)
    end
end

-- depo dolunca ne yapilacak
local function DoluIslemYap(Area)
    if Ayarlar.DoluIslem == "egg" then
        EggAc(Area)
    else
        BossFight(Area)
    end
end

----------------------------------------------------------------
-- OTOMATIK UPGRADE
-- Upgrade verisi: Library.EventUpgrades (HatchWarOrbPower, HatchWarOrbBank, HatchWarOrbSpawn, ... her biri 5 seviye)
-- Satin alma yolu ve seviye kaydi oyun surumune gore degisebildigi icin otomatik aranir, bulunan konsola yazilir.
----------------------------------------------------------------
local UpgVeri
local UpgSatinAl          -- function(Id) -> ok, sonuc
local UpgSeviyeOku        -- function(Id) -> seviye (number) ya da nil
local UpgHazir = false
local UpgLog = 0

local function UpgKur()
    UpgHazir = true

    UpgVeri = Library and Library.EventUpgrades
    if type(UpgVeri) ~= "table" then
        pcall(function()
            UpgVeri = require(ReplicatedStorage.Library.Directory:FindFirstChild("EventUpgrades", true))
        end)
    end

    -- 1) oyunun upgrade modulu (Purchase / GetTier fonksiyonu olan)
    for Ad, Mod in pairs(Library or {}) do
        if type(Mod) == "table" and tostring(Ad):lower():find("upgrade") then
            local _, Satin = pcall(function() return Mod.Purchase end)
            local _, Tier = pcall(function() return Mod.GetTier end)

            if not UpgSatinAl and type(Satin) == "function" then
                local Fn = Satin
                UpgSatinAl = function(Id)
                    pcall(function() setthreadidentity(2) end)
                    local Ok, Sonuc = pcall(Fn, Id)
                    pcall(function() setthreadidentity(8) end)
                    return Ok, Sonuc
                end
                print(("[Upg] satin alma: Library.%s.Purchase"):format(tostring(Ad)))
            end

            if not UpgSeviyeOku and type(Tier) == "function" then
                local Fn = Tier
                UpgSeviyeOku = function(Id)
                    local Ok, T = pcall(Fn, Id)
                    return Ok and tonumber(T) or nil
                end
                print(("[Upg] seviye okuma: Library.%s.GetTier"):format(tostring(Ad)))
            end
        end
    end

    -- 2) yedek: adinda upgrade + purchase/buy gecen remote
    if not UpgSatinAl then
        local Net = ReplicatedStorage:FindFirstChild("Network")

        for _, R in ipairs(Net and Net:GetChildren() or {}) do
            local L = R.Name:lower()

            if L:find("upgrade") and (L:find("purchase") or L:find("buy")) and not L:find("pet") then
                local Ad = R.Name
                UpgSatinAl = function(Id) return Iste(Ad, Id) end
                print(("[Upg] satin alma: remote '%s'"):format(Ad))
                break
            end
        end
    end

    -- 3) yedek: seviyeyi kayit verisinden bul (anahtari upgrade ID'si olan sayi)
    if not UpgSeviyeOku then
        local Ok, Save = pcall(function() return Library.Save.Get() end)

        if Ok and type(Save) == "table" then
            local Ornek = Ayarlar.UpgradeOncelik[1]
            local Gorulen = {}

            -- deger sayi da olabilir, {Tier = 3} gibi tablo da
            local function Sayi(V)
                if tonumber(V) then return tonumber(V) end
                if type(V) == "table" then
                    return tonumber(rawget(V, "Tier") or rawget(V, "tier") or rawget(V, "Level") or rawget(V, "level") or rawget(V, "_am"))
                end
            end

            local function Ara(T, Derinlik)
                if Derinlik > 5 or Gorulen[T] then return end
                Gorulen[T] = true

                if Sayi(rawget(T, Ornek)) ~= nil then return T end

                for _, V in pairs(T) do
                    if type(V) == "table" then
                        local Bulunan = Ara(V, Derinlik + 1)
                        if Bulunan then return Bulunan end
                    end
                end
            end

            local Tablo = Ara(Save, 1)

            if Tablo then
                UpgSeviyeOku = function(Id) return Sayi(rawget(Tablo, Id)) or 0 end
                print(("[Upg] seviye okuma: kayit verisi (%s = %s)"):format(Ornek, tostring(UpgSeviyeOku(Ornek))))
            end
        end
    end

    if not UpgSatinAl then
        warn("[Upg] upgrade satin alma yolu bulunamadi; otomatik upgrade kapali.")
    end

    if not UpgSeviyeOku then
        warn("[Upg] upgrade seviyeleri okunamadi; upgrade'ler seviyeye bakmadan sirayla denenecek.")
    end
end

-- seviyeyi upgrade penceresinden oku: "Orb Power III" = seviye 2 (sonraki alinacak III), isim yalniz = seviye 0
local Romen = {I = 1, II = 2, III = 3, IV = 4, V = 5, VI = 6, VII = 7, VIII = 8, IX = 9, X = 10}

local function UpgIsimHam(Id)
    local V = type(UpgVeri) == "table" and UpgVeri[Id]
    return type(V) == "table" and rawget(V, "Name") or nil
end

local function GuiSeviye(Id)
    local Isim = UpgIsimHam(Id)
    local G = LocalPlayer:FindFirstChild("PlayerGui")
    if not Isim or not G then return nil end

    local Kalip = "^%s*" .. Isim:gsub("%p", "%%%0") .. "%s*([IVX]*)%s*$"

    for _, D in ipairs(G:GetDescendants()) do
        if D:IsA("TextLabel") then
            local R = D.Text:match(Kalip)

            if R then
                -- ayni satirda MAX yaziyor mu?
                local Satir = D.Parent

                for _, S in ipairs(Satir and Satir:GetDescendants() or {}) do
                    if (S:IsA("TextLabel") or S:IsA("TextButton")) and S.Text:lower():find("max", 1, true) then
                        return 99
                    end
                end

                return R == "" and 0 or ((Romen[R] or 1) - 1)
            end
        end
    end
end

local function UpgMaxSeviye(Id)
    local V = type(UpgVeri) == "table" and UpgVeri[Id]
    local Costs = type(V) == "table" and rawget(V, "TierCosts")
    return type(Costs) == "table" and #Costs or 5
end

local function UpgIsim(Id)
    local V = type(UpgVeri) == "table" and UpgVeri[Id]
    return type(V) == "table" and rawget(V, "Name") or Id
end

-- doner: true = bir upgrade alindi
local function UpgradeTur()
    if not UpgHazir then UpgKur() end
    if not UpgSatinAl then return false end

    for _, Id in ipairs(Ayarlar.UpgradeOncelik or {}) do
        local Seviye = (UpgSeviyeOku and UpgSeviyeOku(Id)) or GuiSeviye(Id)
        local Max = UpgMaxSeviye(Id)

        if not (Seviye and Seviye >= Max) then
            local Ok, Sonuc = UpgSatinAl(Id)
            task.wait(0.5)
            local Yeni = (UpgSeviyeOku and UpgSeviyeOku(Id)) or GuiSeviye(Id)

            -- tani: ilk denemelerin sonucunu yaz
            UpgLog = (UpgLog or 0) + 1
            if UpgLog <= 6 then
                print(("[Upg] deneme %s (seviye %s) -> ok=%s sonuc=%s"):format(
                    UpgIsim(Id), tostring(Seviye or "?"), tostring(Ok), tostring(Sonuc)))
            end
            local Alindi = (Seviye and Yeni and Yeni > Seviye) or (Ok and Sonuc ~= false and Sonuc ~= nil)

            if Alindi then
                print(("[Upg] ALINDI: %s -> seviye %s/%d"):format(UpgIsim(Id), tostring(Yeni or "?"), Max))
                return true
            end

            -- "sirali" modda para ilk eksik upgrade'e saklanir, alttakilere gecilmez
            if Ayarlar.UpgradeMod ~= "yettikce" then return false end
        end
    end

    return false
end

-- upgrade noktasi: ayar ya da event modelinde adinda "upgrade" gecen parca
local UpgNoktaUyari = false

local function UpgradeNoktasi()
    if typeof(Ayarlar.UpgradeKonum) == "Vector3" then return Ayarlar.UpgradeKonum, "UpgradeKonum ayari" end

    local Event = EventModeli()
    local En, EnAd

    for _, D in ipairs(Event and Event:GetDescendants() or {}) do
        if (D:IsA("BasePart") or D:IsA("Model")) and D.Name:lower():find("upgrade", 1, true) then
            local P = ObjPos(D)
            if P then
                -- pad / touch parcasi varsa onu tercih et
                local Touch = D:IsA("BasePart") and D:FindFirstChildOfClass("TouchTransmitter")
                if not En or Touch then En, EnAd = P, D:GetFullName() end
                if Touch then break end
            end
        end
    end

    if not En and not UpgNoktaUyari then
        UpgNoktaUyari = true
        warn("[Upg] upgrade noktasi bulunamadi. Ayarlar.UpgradeKonum'a konumu yaz (aciklama ayarlarda).")
    end

    return En, EnAd
end

-- upgrade noktasina git, alinabilenleri al, eski yere don
local SonrakiUpg = os.clock() + 10

local function UpgradeZiyaret()
    if not Ayarlar.OtoUpgrade or os.clock() < SonrakiUpg then return end
    SonrakiUpg = os.clock() + Ayarlar.UpgradeAraligi

    if not UpgHazir then UpgKur() end
    if not UpgSatinAl then return end

    local Nokta, Ad = UpgradeNoktasi()
    if not Nokta then return end

    local HRP = Root()
    if not HRP then return end

    local Eski = HRP.CFrame

    Isinlan(Nokta + Vector3.new(0, 3, 0))
    task.wait(1.2) -- sunucu konumu gorsun / pencere acilsin

    local Alinan = 0
    local Ok, Err = pcall(function()
        for _ = 1, 10 do
            if not UpgradeTur() then break end
            Alinan += 1
            task.wait(0.4)
        end
    end)

    if not Ok then warn("[Upg] hata: " .. tostring(Err)) end

    if Alinan > 0 or UpgLog <= 6 then
        print(("[Upg] upgrade noktasi (%s): %d upgrade alindi."):format(tostring(Ad), Alinan))
    end

    HRP = Root()
    if HRP then
        HRP.CFrame = Eski
        HRP.AssemblyLinearVelocity = Vector3.zero
    end
end

----------------------------------------------------------------
-- ANA DONGU
----------------------------------------------------------------
local AreaUyari = false
local SonArea
local SonBSayi, SonBYazim

print("[Orb] lucky orb farm + boss fight / egg basladi.")
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

    -- arada bir upgrade noktasina gidip upgrade al
    UpgradeZiyaret()

    -- son area'da coin flag
    FlagKontrol(Area)

    -- coin cok birikince (orb'dan bagimsiz) egg ac
    if Ayarlar.CoinEgg and CoinOku() >= Ayarlar.CoinUst then
        EggAc(Area, "coin")
        continue
    end

    -- depo dolu: boss fight (ya da egg). Fight'tan sonra hemen orb toplamaya donulur,
    -- depo tekrar dolunca yeni fight atilir (fight luck'i en yuksekken oynanir)
    if DepoDoluMu() then
        DoluIslemYap(Area)
        continue
    end

    local Orbs = Orblar(Area)

    if #Orbs > 0 then
        if OrblariTopla(Orbs) then
            DoluIslemYap(Area)
        end
    else
        -- orb yok: breakable'larin ortasinda bekle, pet'ler kirsin
        local BMerkez, BSayi = BreakableMerkezi(Area)
        local Merkez = BMerkez or (Area and Area.Position)

        -- tani: area'daki breakable sayisi degisince yaz (30 sn'de bir en fazla)
        if (BSayi or 0) ~= SonBSayi and os.clock() - (SonBYazim or 0) > 30 then
            SonBSayi, SonBYazim = BSayi or 0, os.clock()
            print(("[Farm] area'da %d breakable var%s"):format(BSayi or 0,
                BSayi and " -> ortalarinda bekleniyor" or " (pet'lerin kiracagi bir sey yok)"))
        end

        if Merkez and (HRP.Position - Merkez).Magnitude > 12 then
            Isinlan(Merkez + Vector3.new(0, 4, 0))
        end
    end

    task.wait(Ayarlar.TaramaAraligi)
end

print(("[Orb] durduruldu. Orb: %d | egg turu: %d"):format(ToplamOrb, ToplamEgg))

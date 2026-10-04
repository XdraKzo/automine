-- PS99 HALLOWEEN EVENT (HatchWar) LUCKY ORB FARM + BOSS FIGHT / EGG
-- 1) Event'te degilsen otomatik girer, son area'ya (OrbAreas.ZoneN) gecer.
-- 2) Orb varsa toplar; orb yoksa breakable'larin ortasinda bekler (pet'ler kendileri kirar).
-- 3) Orb deposu dolunca boss fight atar (ekrana hizli tiklar, baloncuklara basar).
--    Boss fight ayri zamanlayiciyla: 3 fight (Luck Flame 3), flame bitene kadar farm, sonra tekrar 3 fight.

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
    BosEsik = 80000,     -- depo dolunca egg acilir, orb bu sayinin altina dusunce orb toplamaya donulur
    HatchAdet = nil,     -- tek seferde acilacak egg sayisi. nil = oyunun kabul ettigi en yuksek sayi deneyerek bulunur
    HatchAraligi = 0.3,  -- hatch istekleri arasi bekleme (sn)
    AnimasyonGec = true, -- egg acarken "Click to open!" animasyonunu otomatik tikla
    DoluSeri = 4,        -- depo neredeyse doluyken ust uste bu kadar orb toplanamazsa "dolu" say
    EggKonum = nil,      -- egg otomatik bulunamazsa: egg'in onunde dur, F9'da
                         -- print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
                         -- calistir ve cikani buraya yaz: EggKonum = Vector3.new(x, y, z)
    AutoHatchAc = true,  -- egg'e varinca oyunun auto hatch'ini ac
    EggMaxSure = 600,    -- egg'de en fazla bu kadar sn kal
    EggTakilma = 45,     -- sayac bu kadar sn hic azalmazsa (hatch olmuyor) farma don

    -- TIKLAYARAK FARM: en yakin breakable'a oyuncu olarak vur (Breakables_PlayerDealDamage)
    -- area'da farm atarken de egg acarken de calisir (menzildeki breakable'a), boss fight'ta durur
    TiklaFarm = true,
    TiklaAraligi = 0.1,  -- vurus araligi (sn). 0.1 = saniyede 10 vurus
    TiklaMesafe = 60,    -- karaktere bu kadar stud yakin breakable'lara vurulur

    -- ORB: false = orb hic toplanmaz, sadece son area'da breakable / coin farmi (egg sadece coin ile acilir)
    OrbTopla = false,

    -- DOLUNCA NE YAPILSIN: "boss" = boss fight, "egg" = egg ac
    DoluIslem = "egg",

    -- BOSS FIGHT
    BossZone = 4,        -- hangi area'nin boss'u (4 = Warlock Ahmad). "max" = en yuksek
    TiklamaAraligi = 0.03, -- fight sirasinda ekrana tiklama araligi (sn)
    FightMaxSure = 180,  -- bir fight en fazla bu kadar sn surer, sonra birakilir
    FightArasi = 3,      -- iki fight arasi bekleme (sn)
    -- BOSS SERISI: ust uste BossSeriSayisi fight at (3 fight = Luck Flame 3), sonra flame bitene kadar
    -- (FlameSuresi sn) farm at, sonra tekrar seri. Depo bu arada dolarsa egg acilir (BosEsik'e kadar).
    BossSeri = false,    -- simdilik kapali (coin farm modu)
    BossSeriSayisi = 3,  -- kacinci Luck Flame yanana kadar fight atilsin (3 = Flame III)
    BossMaxFight = 6,    -- bir seride en fazla kac fight (kaybedilenler flame yakmaz)
    FlameSuresi = nil,   -- luck flame suresi (sn). nil = oyundaki flame sayacindan kendisi ogrenir

    -- COIN FLAG: son area'da flag dik (FlexibleFlags_Consume)
    OtoFlag = true,
    FlagAdi = "Coins Flag", -- envanterdeki flag'in adi (ornek: "Coins Flag", "Diamonds Flag", "Magnet Flag")
    FlagAraligi = 60,    -- iki flag dikme arasi en az bekleme (sn). Area'da flag gorunuyorsa hic dikilmez

    -- COIN ILE EGG: event coin'i cok birikince (orb'dan bagimsiz) egg ac
    CoinEgg = true,
    CoinId = "HatchWarCoins", -- egg'in parasi
    CoinUst = 2e9,       -- coin bu kadar olunca egg acmaya git (2e9 = 2b)
    CoinAlt = 2e8,       -- coin bu kadara dusunce egg'i birak (2e8 = 200m)

    -- OTOMATIK UPGRADE (asa/wand parasiyla)
    OtoUpgrade = false,  -- kapali: upgrade penceresi ekranda kalip boss fight'i engelliyordu
    -- oncelik sirasi (ID'ler). Listede olmayan upgrade'lere hic dokunulmaz.
    UpgradeOncelik = {"HatchWarOrbPower", "HatchWarOrbBank", "HatchWarOrbSpawn"},
    -- "sirali"  = ilk upgrade max olana kadar sadece onu al (para ona saklanir), sonra siradakine gec
    -- "yettikce" = listeyi sirayla dene, parasi yeten ilkini al
    UpgradeMod = "sirali",
    UpgradeAraligi = 90, -- kac sn'de bir upgrade noktasina gidilsin
    -- upgrade noktasi otomatik bulunamazsa: noktada dur, F9'da
    -- print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position) calistir, cikani yaz:
    UpgradeKonum = nil,  -- ornek: Vector3.new(100, 20, -300)

    -- ISTATISTIK PANELI
    Panel = true,
    PanelTus = "RightShift", -- paneli gizle / goster
    TakipEgg = "Witching Egg", -- sagdaki tabloda petleri sayilacak egg
    PanelRenderKapat = true, -- panel acikken 3D cizimi kapat + fps sinirla (CPU / GPU tasarrufu)
    PanelFPS = 20,       -- panel acikken fps siniri
    NormalFPS = 60,      -- panel kapaninca fps
    PanelFightKucuk = false, -- true: boss fight sirasinda tam ekran yerine sag kenarda kucuk panel

    -- CPU / RAM TASARRUFU
    CPUSaver = true,     -- en dusuk grafik, ses kapali, golge / dekor kapali (panel kapaliysa 3D + fps de)
    RamSaver = true,     -- doku / efekt / diger oyuncu karakterleri silinir (orb, breakable, egg'e dokunulmaz)
    RamSaverAgresif = false, -- true: sesler + sus esyalari (ornament vb.) da silinir (daha cok RAM, gorunum bozulur)

    TaramaAraligi = 0.2, -- tur arasi bekleme (sn)
    AntiAFK = true,
}

-- eski kopyayi durdur
getgenv().OrbRunId = (rawget(getgenv(), "OrbRunId") or 0) + 1
local RunId = getgenv().OrbRunId
local function Aktif() return getgenv().OrbRunId == RunId end

-- panel icin sayaclar
local Istat = {Egg = 0, Fight = 0, Kazanilan = 0, Kaybedilen = 0, Flag = 0, Seri = 0, Baslangic = os.clock()}
local Durum = "Starting"

-- luck flame suresi: ayarda yoksa oyundaki flame sayacinda gorulen en uzun sure
local OgrenilenFlame
local function FlameSure()
    return tonumber(Ayarlar.FlameSuresi) or OgrenilenFlame or 600
end

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
    if N >= 1e12 then return ("%.2ft"):format(N / 1e12) end
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
        Istat.Egg += Adet

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
-- ekranin ortasina tikla (egg acilis animasyonu "Click to open!" ekranda kalmasin)
local function EggEkranTikla()
    local Kamera = workspace.CurrentCamera
    local Boyut = Kamera and Kamera.ViewportSize or Vector2.new(800, 600)
    local X, Y = Boyut.X / 2, Boyut.Y / 2

    pcall(function()
        VIM:SendMouseButtonEvent(X, Y, 0, true, game, 1)
        VIM:SendMouseButtonEvent(X, Y, 0, false, game, 1)
    end)
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(X, Y))
    end)
end

local function EggAcIc(Area, Mod)
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
    Durum = Mod == "coin" and "Hatching eggs (coins)" or "Hatching eggs (orb bank full)"

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
        if Ayarlar.AnimasyonGec then EggEkranTikla() end

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
            -- depo kapasitesi BosEsik'ten kucukse (ornek 67.5k < 80k) kapasitenin %90'ina kadar ac
            local Esik = tonumber(Ayarlar.BosEsik) or 10000
            if Max and Esik >= Max * 0.95 then Esik = Max * 0.9 end

            if Su < Esik then
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

-- egg ac, sonra ekranda kalan egg'leri tiklayarak kapat (yoksa boss fight / diger islemler takiliyor)
local function EggAc(Area, Mod)
    EggAcIc(Area, Mod)

    Durum = "Closing hatch screen"
    for _ = 1, 15 do
        EggEkranTikla()
        task.wait(0.2)
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

----------------------------------------------------------------
-- LUCK FLAME okuma: event'teki "Luck Flame I / II / III" yazilari ("Lit" ya da "07:49" = yanik)
-- Fight'i kazanip kazanmadigimizi da buradan anlariz (fight sonrasi yanik flame sayisi artti mi).
----------------------------------------------------------------
local RomenSayi = {I = 1, II = 2, III = 3, IV = 4, V = 5}
local FlameEtiketleri = {}  -- {No, Gui}
local FlameTarandi = -math.huge
local FlameYazildi = false

-- RichText etiketlerini (<b>, <font ...>) temizle
local function DuzYazi(D)
    local Ok, T = pcall(function() return D.ContentText end)
    T = (Ok and type(T) == "string" and T ~= "") and T or D.Text
    return (T:gsub("<[^>]->", ""))
end

local FlameBulunamadiYazildi = false
local SonDunyaTaramasi = -math.huge

local function FlameTara()
    FlameEtiketleri = {}

    local Event = EventModeli()
    if not Event then return end -- event disinda flame yok (tarandi sayilmaz, girince hemen bakilir)

    FlameTarandi = os.clock()

    local function Tara(Kok)
        for _, D in ipairs(Kok:GetDescendants()) do
            if D:IsA("TextLabel") then
                local R = DuzYazi(D):match("^%s*Luck Flame%s+([IV]+)%s*$")
                local Gui = R and (D:FindFirstAncestorWhichIsA("BillboardGui") or D:FindFirstAncestorWhichIsA("SurfaceGui") or D.Parent)

                if R and RomenSayi[R] and Gui then
                    table.insert(FlameEtiketleri, {No = RomenSayi[R], Gui = Gui, Baslik = D})
                end
            end
        end
    end

    -- kafa ustu yazilar cogu zaman PlayerGui'de (Adornee ile direge bagli), bazen event modelinde
    local G = PG()
    if G then Tara(G) end
    if #FlameEtiketleri == 0 then Tara(Event) end

    -- hala yoksa tum dunyaya bak (agir; en fazla dakikada bir)
    if #FlameEtiketleri == 0 and os.clock() - SonDunyaTaramasi > 60 then
        SonDunyaTaramasi = os.clock()
        Tara(workspace)
    end

    if #FlameEtiketleri == 0 then
        if not FlameBulunamadiYazildi then
            FlameBulunamadiYazildi = true
            warn("[Flame] 'Luck Flame' yazilari bulunamadi; boss serisi sureyle takip edilecek.")
        end
    else
        local Yerler = {}
        for _, E in ipairs(FlameEtiketleri) do table.insert(Yerler, E.No .. "@" .. E.Gui:GetFullName()) end
        print("[Flame] bulundu: " .. table.concat(Yerler, " | "))
    end
end

-- doner: {[1] = {Yanik, Kalan, Ham}, ...} ya da nil (flame bulunamadi)
local function FlameDurumu()
    local Bozuk = #FlameEtiketleri == 0
    for _, E in ipairs(FlameEtiketleri) do
        if not E.Gui.Parent then Bozuk = true break end
    end

    if Bozuk and os.clock() - FlameTarandi > (#FlameEtiketleri == 0 and 5 or 15) then FlameTara() end
    if #FlameEtiketleri == 0 then return nil end

    local Sonuc = {}

    for _, E in ipairs(FlameEtiketleri) do
        local Parca = {}

        for _, D in ipairs(E.Gui:GetDescendants()) do
            local T = (D:IsA("TextLabel") or D:IsA("TextButton")) and D ~= E.Baslik and DuzYazi(D) or ""
            if T ~= "" and not T:lower():find("luck") then
                table.insert(Parca, T)
            end
        end

        local Ham = table.concat(Parca, " ")
        local Dk, Sn = Ham:match("(%d+):(%d%d)")
        local Yanik = Ham:lower():find("lit") ~= nil and not Ham:lower():find("unlit") or Dk ~= nil

        local Kalan = Dk and (tonumber(Dk) * 60 + tonumber(Sn)) or nil
        if Kalan then OgrenilenFlame = math.max(OgrenilenFlame or 0, Kalan) end

        Sonuc[E.No] = {Yanik = Yanik, Kalan = Kalan, Ham = Ham}
    end

    if not FlameYazildi then
        FlameYazildi = true
        local Parca = {}
        for No, F in pairs(Sonuc) do
            table.insert(Parca, ("%d=%s (%q)"):format(No, F.Yanik and "YANIK" or "sonuk", F.Ham))
        end
        table.sort(Parca)
        print("[Flame] okunan: " .. table.concat(Parca, " | "))
    end

    return Sonuc
end

local function YanikSayisi(Durum_)
    local N = 0
    for _, F in pairs(Durum_ or {}) do
        if F.Yanik then N += 1 end
    end
    return N
end

-- fight ekranindaki "Win Chance: 81%" yazisi (flame okunamazsa sonuc tahmini icin)
local WinEtiket
local WinAramaZamani = -math.huge

local function WinChanceOku()
    if not (WinEtiket and WinEtiket.Parent) and os.clock() - WinAramaZamani > 1 then
        WinAramaZamani = os.clock()
        WinEtiket = nil
        local G = PG()
        local Inst = G and G:FindFirstChild("_INSTANCES")

        for _, D in ipairs((Inst or G) and (Inst or G):GetDescendants() or {}) do
            if D:IsA("TextLabel") and D.Text:find("Win Chance", 1, true) then WinEtiket = D break end
        end
    end

    return WinEtiket and tonumber(WinEtiket.Text:match("Win Chance:%s*(%d+)"))
end

local function BossFight(Area)
    local Boss = BossModeli()

    if not Boss then
        if not BossUyari then
            BossUyari = true
            warn("[Boss] boss bulunamadi (INTERACT.Bosses.Boss" .. tostring(Ayarlar.BossZone) .. ").")
        end

        task.wait(5)
        return false
    end

    local Pos = BossPos(Boss)
    if not Pos then task.wait(5) return false end

    -- boss'un onunde dur (area tarafina dogru 8 stud)
    local Yon = Area and (Area.Position - Pos) * Vector3.new(1, 0, 1) or Vector3.new(0, 0, 1)
    Yon = Yon.Magnitude > 0.1 and Yon.Unit or Vector3.new(0, 0, 1)
    local Durak = Pos + Yon * 8 + Vector3.new(0, 3, 0)

    print(("[Boss] boss fight: %s"):format(Boss.Name))

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
        return false
    end

    local FlameOnce = FlameDurumu()
    local OnceYanik = YanikSayisi(FlameOnce)

    ToplamFight += 1
    Istat.Fight += 1
    Durum = ("Boss fight #%d"):format(ToplamFight)
    print(("[Boss] fight basladi (#%d)."):format(ToplamFight))

    local Basla = os.clock()
    local Baloncuk = 0
    local Kamera = workspace.CurrentCamera
    local SonWin

    while FightAktif() and Aktif() and os.clock() - Basla < Ayarlar.FightMaxSure do
        -- ekrana hizli tikla (ortaya)
        local Boyut = Kamera and Kamera.ViewportSize or Vector2.new(800, 600)
        EkranaTikla(Boyut.X / 2, Boyut.Y / 2)

        -- baloncuk cikarsa hemen bas
        Baloncuk += BaloncuklaraBas()

        SonWin = WinChanceOku() or SonWin

        task.wait(Ayarlar.TiklamaAraligi)
    end

    -- sonuc: once yanik flame sayisi (kesin), olmazsa son "Win Chance" (tahmin)
    task.wait(1.5)
    local Flame = FlameDurumu()
    local Sonuc

    if Flame and FlameOnce then
        Sonuc = YanikSayisi(Flame) > OnceYanik and "win" or "loss"
    end

    if Sonuc == "win" then
        Istat.Kazanilan += 1
    elseif Sonuc == "loss" then
        Istat.Kaybedilen += 1
    end

    print(("[Boss] fight bitti: %s | yanik flame %d -> %s | son win chance %s | %.0f sn, %d baloncuk"):format(
        Sonuc == "win" and "KAZANDIN" or Sonuc == "loss" and "kaybettin" or "?", OnceYanik,
        Flame and tostring(YanikSayisi(Flame)) or "?", SonWin and (SonWin .. "%") or "?", os.clock() - Basla, Baloncuk))

    task.wait(Ayarlar.FightArasi)
    return true, Sonuc
end

----------------------------------------------------------------
-- BOSS SERISI: Luck Flame III yanana kadar fight at (kaybedilen fight flame yakmaz,
-- o yuzden sayi degil flame'e bakilir). III yanikken farm; sonunce yeni seri.
-- Oyuna girince flame'ler zaten yaniyorsa once sonmeleri beklenir.
-- Flame'ler hic okunamazsa eski usul: BossSeriSayisi fight + FlameSuresi bekleme.
----------------------------------------------------------------
local SonrakiSeri = 0
local FlameBekleYazildi = false
local FlameYuklemeDenemesi = 0
local SeriYarim = false -- son seri III'u yakamadan bitti: I / II bizim, sonmelerini bekleme, devam et

local function BossSeriKontrol(Area)
    if not Ayarlar.BossSeri or os.clock() < SonrakiSeri then return false end

    local Hedef = Ayarlar.BossSeriSayisi or 3
    local MaxFight = Ayarlar.BossMaxFight or 6
    local Flame = FlameDurumu()

    -- event'e yeni girildiyse direkler henuz yuklenmemis olabilir: flame'leri ~15 sn bekle
    if not (Flame and Flame[Hedef]) and FlameYuklemeDenemesi < 5 then
        FlameYuklemeDenemesi += 1
        SonrakiSeri = os.clock() + 3
        return false
    end

    if Flame and Flame[Hedef] then
        FlameYuklemeDenemesi = 0

        -- hedef flame yanik: sonene kadar farm
        if Flame[Hedef].Yanik then
            SeriYarim = false
            SonrakiSeri = os.clock() + math.clamp((Flame[Hedef].Kalan or 15) - 2, 5, 600)
            return false
        end

        -- baska flame'ler yaniyor (ornek: oyuna girince onceki oturumdan): sonmelerini bekle
        if YanikSayisi(Flame) > 0 and not SeriYarim then
            local EnUzun
            for _, F in pairs(Flame) do
                if F.Yanik and F.Kalan then EnUzun = math.max(EnUzun or 0, F.Kalan) end
            end

            SonrakiSeri = os.clock() + math.clamp((EnUzun or 15) - 2, 5, 600)

            if not FlameBekleYazildi then
                FlameBekleYazildi = true
                print(("[Boss] %d Luck Flame hala yaniyor -> sonmesi bekleniyor (%s), sonra yeni seri."):format(
                    YanikSayisi(Flame), EnUzun and (math.floor(EnUzun) .. " sn") or "sure okunamadi, 15 sn'de bir bakiliyor"))
            end

            return false
        end

        if YanikSayisi(Flame) == 0 then SeriYarim = false end
        FlameBekleYazildi = false
    end

    print(("[Boss] seri basliyor: Luck Flame %d yanana kadar fight%s."):format(Hedef,
        (Flame and Flame[Hedef]) and (" (yanik: " .. YanikSayisi(Flame) .. ")") or " (flame okunamiyor, " .. Hedef .. " fight atilacak)"))

    local Fight, Basarisiz = 0, 0

    while Aktif() and Basarisiz < 3 do
        -- her fight'tan once flame'lere bak (seri ortasinda okunur hale gelebilir)
        Flame = FlameDurumu()

        if Flame and Flame[Hedef] then
            if Flame[Hedef].Yanik or Fight >= MaxFight then break end
            Durum = ("Lighting Luck Flame (%d/%d lit)"):format(YanikSayisi(Flame), Hedef)
        else
            if Fight >= Hedef then break end
            Durum = ("Boss series (%d/%d)"):format(Fight, Hedef)
        end

        if BossFight(Area) then Fight += 1 else Basarisiz += 1 end
    end

    Flame = FlameDurumu()

    if Flame and Flame[Hedef] then
        if Flame[Hedef].Yanik then
            Istat.Seri += 1
            SeriYarim = false
            SonrakiSeri = os.clock() + math.clamp((Flame[Hedef].Kalan or FlameSure()) - 2, 5, 900)
            print(("[Boss] Luck Flame %d YANDI (%d fight). Sonene kadar farm."):format(Hedef, Fight))
        else
            -- III yanmadi ama I / II bizim: sonmelerini bekleme, 1 dk farm sonra devam
            SeriYarim = YanikSayisi(Flame) > 0
            SonrakiSeri = os.clock() + 60
            warn(("[Boss] %d fight'ta Luck Flame %d yanmadi (yanik: %d). 1 dk sonra devam edilecek."):format(
                Fight, Hedef, YanikSayisi(Flame)))
        end
    elseif Fight >= Hedef then
        Istat.Seri += 1
        SonrakiSeri = os.clock() + FlameSure()
        print(("[Boss] seri bitti (%d fight, flame okunamadi). %d sn farm, sonra yeni seri."):format(Fight, FlameSure()))
    else
        SonrakiSeri = os.clock() + 60
        warn(("[Boss] seri tamamlanamadi (%d fight). 1 dk sonra tekrar denenecek."):format(Fight))
    end

    return true
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
    if Ok and Sonuc then Istat.Flag += 1 end

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
-- ISTATISTIK EKRANI (tam ekran, Ingilizce). RightShift ile gizle / goster.
-- Panel tiklamalari yutmaz (Active = false), fight sirasinda da acik kalir (PanelFightKucuk = true: kucuk panel).
-- PanelRenderKapat: panel acikken 3D cizim kapanir + PanelFPS ile fps sinirlanir (CPU / GPU tasarrufu).
----------------------------------------------------------------
local TakipPetler = {}   -- {Ad, Sans}
local TakipSet = {}
local PetBaslangic       -- ilk sayim (id -> adet)
local PetSimdi = {}      -- son sayim
local PetOnceki
local SonCikanlar = {}   -- {Ad, Zaman, Adet}

pcall(function()
    local Eggs = require(ReplicatedStorage.Library.Directory:FindFirstChild("Eggs", true))
    local Veri = rawget(Eggs, Ayarlar.TakipEgg)

    for _, P in ipairs(type(Veri) == "table" and rawget(Veri, "pets") or {}) do
        table.insert(TakipPetler, {Ad = tostring(P[1]), Sans = tonumber(P[2])})
        TakipSet[tostring(P[1])] = tonumber(P[2]) or 0
    end
end)

local function HugeMi(Id) return Id:sub(1, 5) == "Huge " end
local function TitanicMi(Id) return Id:sub(1, 8) == "Titanic " end

-- nadir sayilan pet: takip edilen egg'de sansi %0.001'den dusuk olanlar + tum Huge / Titanic
local function NadirMi(Id)
    local Sans = TakipSet[Id]
    return HugeMi(Id) or TitanicMi(Id) or (Sans ~= nil and Sans > 0 and Sans < 0.001)
end

local function PetleriSay()
    local Save = SaveGet()
    local Sayim = {}

    for Kategori, Esyalar in pairs(Save and Save.Inventory or {}) do
        if type(Esyalar) == "table" and tostring(Kategori):lower():find("pet") then
            for _, E in pairs(Esyalar) do
                local Id = type(E) == "table" and tostring(E.id) or ""

                if TakipSet[Id] or HugeMi(Id) or TitanicMi(Id) then
                    Sayim[Id] = (Sayim[Id] or 0) + (tonumber(E._am) or 1)
                end
            end
        end
    end

    -- yeni cikan nadirler
    if PetOnceki then
        for Id, Adet in pairs(Sayim) do
            local Fark = Adet - (PetOnceki[Id] or 0)

            if Fark > 0 and NadirMi(Id) then
                table.insert(SonCikanlar, 1, {Ad = Id, Zaman = os.clock(), Adet = Fark})
                if #SonCikanlar > 6 then table.remove(SonCikanlar) end
                print(("[Panel] CIKTI: %s x%d"):format(Id, Fark))
            end
        end
    end

    PetBaslangic = PetBaslangic or Sayim
    PetOnceki = Sayim
    PetSimdi = Sayim
end

-- kayitta "hatch" sayaci (fight sirasinda acilan egg'ler script'in sayacina girmiyor)
local HatchYolu, HatchBaslangic
local HatchArandi = false

local function HatchSayaci()
    local Save = SaveGet()
    if not Save then return nil end

    if not HatchArandi then
        HatchArandi = true
        local Adaylar = {}

        local function Ara(T, Yol, Derinlik)
            for K, V in pairs(T) do
                local Ad = tostring(K)
                if type(V) == "number" and Ad:lower():find("hatch") then
                    table.insert(Adaylar, {Yol = Yol .. Ad, Deger = V, Puan = Ad:lower():find("egg") and 1 or 0})
                elseif type(V) == "table" and Derinlik < 2 and not Ad:lower():find("inventory") then
                    Ara(V, Yol .. Ad .. ".", Derinlik + 1)
                end
            end
        end

        Ara(Save, "", 1)
        table.sort(Adaylar, function(a, b) return a.Puan > b.Puan end)

        local Yazilar = {}
        for I = 1, math.min(#Adaylar, 6) do table.insert(Yazilar, Adaylar[I].Yol .. "=" .. tostring(Adaylar[I].Deger)) end
        print("[Panel] hatch sayaci adaylari: " .. (#Yazilar > 0 and table.concat(Yazilar, ", ") or "yok"))

        HatchYolu = Adaylar[1] and Adaylar[1].Yol
    end

    if not HatchYolu then return nil end

    local V = Save
    for Parca in HatchYolu:gmatch("[^%.]+") do
        V = type(V) == "table" and V[Parca] or nil
    end

    V = tonumber(V)
    if not V then return nil end

    HatchBaslangic = HatchBaslangic or V
    return V - HatchBaslangic
end

local function OturumAdet(Id)
    return math.max(0, (PetSimdi[Id] or 0) - (PetBaslangic and PetBaslangic[Id] or 0))
end

local function OturumToplam(Kosul)
    local N = 0
    for Id in pairs(PetSimdi) do
        if Kosul(Id) then N += OturumAdet(Id) end
    end
    return N
end

local function SureYaz(Sn)
    Sn = math.max(0, math.floor(Sn))
    local S, D = Sn // 3600, (Sn % 3600) // 60
    if S > 0 then return ("%dh %02dm"):format(S, D) end
    return ("%dm %02ds"):format(D, Sn % 60)
end

local function SaatYaz(Sn)
    Sn = math.max(0, math.floor(Sn))
    return ("%02d:%02d:%02d"):format(Sn // 3600, (Sn % 3600) // 60, Sn % 60)
end

local function PanelKur()
    if not Ayarlar.Panel then return end

    pcall(function() if getgenv().OrbPanel then getgenv().OrbPanel:Destroy() end end)

    local UIS = game:GetService("UserInputService")
    local RunS = game:GetService("RunService")

    local R = {
        Arka = Color3.fromRGB(13, 10, 20),
        Kart = Color3.fromRGB(26, 21, 38),
        Kart2 = Color3.fromRGB(34, 27, 50),
        Iz = Color3.fromRGB(45, 38, 64),
        Turuncu = Color3.fromRGB(255, 140, 40),
        Mor = Color3.fromRGB(190, 120, 255),
        Altin = Color3.fromRGB(255, 205, 80),
        Yesil = Color3.fromRGB(100, 225, 135),
        Kirmizi = Color3.fromRGB(255, 105, 105),
        Mavi = Color3.fromRGB(90, 170, 255),
        Soluk = Color3.fromRGB(150, 143, 175),
        Yazi = Color3.fromRGB(243, 240, 252),
    }

    local function Yeni(Sinif, Ozellik, Ebeveyn)
        local O = Instance.new(Sinif)
        for K, V in pairs(Ozellik or {}) do O[K] = V end
        O.Parent = Ebeveyn
        return O
    end

    local function Kose(O, N) Yeni("UICorner", {CornerRadius = UDim.new(0, N)}, O) end

    local function Kenar(O, Renk, Kalinlik, Seffaf)
        Yeni("UIStroke", {Color = Renk, Thickness = Kalinlik or 1.5, Transparency = Seffaf or 0.45,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, O)
    end

    local function Yazi(Ebeveyn, Ozellik)
        local T = {BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = R.Yazi,
            RichText = true, TextXAlignment = Enum.TextXAlignment.Left}
        for K, V in pairs(Ozellik) do T[K] = V end
        return Yeni("TextLabel", T, Ebeveyn)
    end

    local Gui = Yeni("ScreenGui", {Name = "HatchWarPanel", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999})

    local Ok = pcall(function() Gui.Parent = gethui and gethui() or game:GetService("CoreGui") end)
    if not Ok or not Gui.Parent then Gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    getgenv().OrbPanel = Gui

    ------------------------------------------------------------
    -- TAM EKRAN
    ------------------------------------------------------------
    local Ekran = Yeni("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = R.Arka, BorderSizePixel = 0, Active = false}, Gui)
    Yeni("UIGradient", {Rotation = 120, Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 16, 46)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(14, 11, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 14, 10)),
    })}, Ekran)

    local Kap = Yeni("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1700, 940), BackgroundTransparency = 1}, Ekran)

    local Olcek = Yeni("UIScale", {}, Kap)
    local function OlcekAyarla()
        local V = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
        Olcek.Scale = math.clamp(math.min(V.X / 1780, V.Y / 1000), 0.4, 1.6)
    end
    OlcekAyarla()
    pcall(function() workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(OlcekAyarla) end)

    -- UST BASLIK
    local Ust = Yeni("Frame", {Size = UDim2.new(1, 0, 0, 100), BackgroundColor3 = R.Kart2, BorderSizePixel = 0}, Kap)
    Kose(Ust, 16)
    Kenar(Ust, R.Turuncu, 2, 0.35)

    Yazi(Ust, {Position = UDim2.fromOffset(28, 16), Size = UDim2.fromOffset(500, 40), Font = Enum.Font.GothamBlack,
        TextSize = 34, TextColor3 = R.Turuncu, Text = "HATCHWAR FARM"})
    Yazi(Ust, {Position = UDim2.fromOffset(30, 60), Size = UDim2.fromOffset(560, 24), TextSize = 16, TextColor3 = R.Soluk,
        Text = ("Halloween event  •  Zone %s  •  %s"):format(tostring(Ayarlar.Zone), Ayarlar.TakipEgg)})

    local SureL = Yazi(Ust, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 10), Size = UDim2.fromOffset(420, 52),
        Font = Enum.Font.GothamBlack, TextSize = 44, TextXAlignment = Enum.TextXAlignment.Center, Text = "00:00:00"})
    Yazi(Ust, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 64), Size = UDim2.fromOffset(420, 22),
        TextSize = 15, TextColor3 = R.Soluk, TextXAlignment = Enum.TextXAlignment.Center, Text = "session time"})

    local Hap = Yeni("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -26, 0.5, 0),
        Size = UDim2.fromOffset(470, 50), BackgroundColor3 = R.Arka, BorderSizePixel = 0}, Ust)
    Kose(Hap, 25)
    Kenar(Hap, R.Altin, 1.5, 0.5)
    local Nokta = Yeni("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 20, 0.5, 0),
        Size = UDim2.fromOffset(12, 12), BackgroundColor3 = R.Yesil, BorderSizePixel = 0}, Hap)
    Kose(Nokta, 6)
    local DurumL = Yazi(Hap, {Position = UDim2.fromOffset(42, 0), Size = UDim2.new(1, -56, 1, 0), Font = Enum.Font.GothamBold,
        TextSize = 18, TextColor3 = R.Altin, TextTruncate = Enum.TextTruncate.AtEnd, Text = "-"})

    -- SOL: KARTLAR
    local Sol = Yeni("Frame", {Position = UDim2.fromOffset(0, 120), Size = UDim2.new(0, 1060, 1, -120), BackgroundTransparency = 1}, Kap)

    local Izgara = Yeni("Frame", {Size = UDim2.new(1, 0, 0, 310), BackgroundTransparency = 1}, Sol)
    Yeni("UIGridLayout", {CellSize = UDim2.fromOffset(254, 148), CellPadding = UDim2.fromOffset(14, 14),
        SortOrder = Enum.SortOrder.LayoutOrder}, Izgara)

    local KartNo = 0
    local function Kart(Baslik, Renk)
        KartNo += 1
        local K = Yeni("Frame", {LayoutOrder = KartNo, BackgroundColor3 = R.Kart, BorderSizePixel = 0}, Izgara)
        Kose(K, 14)
        Kenar(K, Renk, 1.5, 0.55)

        local Serit = Yeni("Frame", {Position = UDim2.fromOffset(0, 18), Size = UDim2.new(0, 5, 1, -36),
            BackgroundColor3 = Renk, BorderSizePixel = 0}, K)
        Kose(Serit, 3)

        Yazi(K, {Position = UDim2.fromOffset(24, 16), Size = UDim2.new(1, -40, 0, 22), Font = Enum.Font.GothamMedium,
            TextSize = 16, TextColor3 = R.Soluk, Text = Baslik})

        local Deger = Yazi(K, {Position = UDim2.fromOffset(22, 44), Size = UDim2.new(1, -40, 0, 60), Font = Enum.Font.GothamBlack,
            TextScaled = true, TextColor3 = Renk, Text = "0"})
        Yeni("UITextSizeConstraint", {MaxTextSize = 50}, Deger)

        local Alt = Yazi(K, {Position = UDim2.fromOffset(24, 108), Size = UDim2.new(1, -40, 0, 22), TextSize = 14,
            TextColor3 = R.Soluk, Text = ""})

        return Deger, Alt
    end

    local EggL, EggAlt = Kart("Eggs hatched", R.Yazi)
    local EggDkL, EggDkAlt = Kart("Eggs / minute", R.Turuncu)
    local BossL, BossAlt = Kart("Bosses defeated", R.Yesil)
    local OranL, OranAlt = Kart("Win rate", R.Mavi)
    local HugeL, HugeAlt = Kart("Huges hatched", R.Mor)
    local TitanL, TitanAlt = Kart("Titanics hatched", R.Altin)
    local OrbL, OrbAlt = Kart("Orbs collected", R.Turuncu)
    local CoinL, CoinAlt = Kart("Event coins", R.Altin)

    -- CUBUKLAR
    local Cubuklar = Yeni("Frame", {Position = UDim2.fromOffset(0, 330), Size = UDim2.new(1, -14, 0, 176),
        BackgroundColor3 = R.Kart, BorderSizePixel = 0}, Sol)
    Kose(Cubuklar, 14)
    Kenar(Cubuklar, R.Iz, 1.5, 0.2)

    local function Cubuk(Y, Baslik, Renk)
        Yazi(Cubuklar, {Position = UDim2.fromOffset(24, Y), Size = UDim2.fromOffset(400, 24), Font = Enum.Font.GothamBold,
            TextSize = 18, Text = Baslik})
        local Sag = Yazi(Cubuklar, {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -24, 0, Y), Size = UDim2.fromOffset(520, 24),
            TextSize = 16, TextColor3 = R.Soluk, TextXAlignment = Enum.TextXAlignment.Right, Text = ""})
        local Iz = Yeni("Frame", {Position = UDim2.fromOffset(24, Y + 32), Size = UDim2.new(1, -48, 0, 18),
            BackgroundColor3 = R.Iz, BorderSizePixel = 0}, Cubuklar)
        Kose(Iz, 9)
        local Dolu = Yeni("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = Renk, BorderSizePixel = 0}, Iz)
        Kose(Dolu, 9)
        return Dolu, Sag
    end

    local OrbBar, OrbBarL = Cubuk(18, "Orb bank", R.Turuncu)
    local FlameBar, FlameBarL = Cubuk(98, "Luck Flame", R.Mor)

    -- SON CIKANLAR
    local Akis = Yeni("Frame", {Position = UDim2.fromOffset(0, 522), Size = UDim2.new(1, -14, 1, -522),
        BackgroundColor3 = R.Kart, BorderSizePixel = 0}, Sol)
    Kose(Akis, 14)
    Kenar(Akis, R.Mor, 1.5, 0.55)
    Yazi(Akis, {Position = UDim2.fromOffset(24, 14), Size = UDim2.fromOffset(500, 26), Font = Enum.Font.GothamBold,
        TextSize = 18, Text = "Recent rare hatches"})
    local AkisL = Yazi(Akis, {Position = UDim2.fromOffset(24, 48), Size = UDim2.new(1, -48, 1, -60), TextSize = 16,
        TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, LineHeight = 1.25, Text = ""})

    -- SAG: PET TABLOSU
    local Sag = Yeni("Frame", {Position = UDim2.fromOffset(1074, 120), Size = UDim2.new(1, -1074, 1, -120),
        BackgroundColor3 = R.Kart, BorderSizePixel = 0}, Kap)
    Kose(Sag, 14)
    Kenar(Sag, R.Turuncu, 1.5, 0.55)

    Yazi(Sag, {Position = UDim2.fromOffset(24, 16), Size = UDim2.new(1, -48, 0, 28), Font = Enum.Font.GothamBlack,
        TextSize = 22, Text = Ayarlar.TakipEgg})
    Yazi(Sag, {Position = UDim2.fromOffset(24, 46), Size = UDim2.new(1, -48, 0, 20), TextSize = 14, TextColor3 = R.Soluk,
        Text = "hatched this session / total in inventory"})

    local function SansRengi(Sans)
        if not Sans or Sans >= 1 then return R.Yazi end
        if Sans >= 0.01 then return R.Yesil end
        if Sans >= 0.00001 then return R.Mavi end
        if Sans >= 1e-9 then return R.Mor end
        return R.Altin
    end

    -- sutun basliklari
    local function Sutunlar(Ebeveyn, Y, A, B, C, D, Renk, Font)
        Yazi(Ebeveyn, {Position = UDim2.fromOffset(46, Y), Size = UDim2.fromOffset(260, 24), Font = Font, TextSize = 16, TextColor3 = Renk, Text = A})
        local L2 = Yazi(Ebeveyn, {Position = UDim2.fromOffset(300, Y), Size = UDim2.fromOffset(100, 24), Font = Font, TextSize = 15,
            TextColor3 = R.Soluk, TextXAlignment = Enum.TextXAlignment.Right, Text = B})
        local L3 = Yazi(Ebeveyn, {Position = UDim2.fromOffset(410, Y), Size = UDim2.fromOffset(90, 24), Font = Font, TextSize = 16,
            TextColor3 = R.Yesil, TextXAlignment = Enum.TextXAlignment.Right, Text = C})
        local L4 = Yazi(Ebeveyn, {Position = UDim2.fromOffset(505, Y), Size = UDim2.fromOffset(100, 24), Font = Font, TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Right, Text = D})
        return L2, L3, L4
    end

    Sutunlar(Sag, 84, "Pet", "Chance", "Session", "Total", R.Soluk, Enum.Font.GothamBold)
    Yeni("Frame", {Position = UDim2.fromOffset(24, 114), Size = UDim2.new(1, -48, 0, 1), BackgroundColor3 = R.Iz, BorderSizePixel = 0}, Sag)

    local PetSatirlari = {}

    for I, P in ipairs(TakipPetler) do
        local Y = 126 + (I - 1) * 56
        local Renk = SansRengi(P.Sans)

        local Satir = Yeni("Frame", {Position = UDim2.fromOffset(16, Y - 8), Size = UDim2.new(1, -32, 0, 44),
            BackgroundColor3 = R.Kart2, BackgroundTransparency = I % 2 == 0 and 1 or 0.3, BorderSizePixel = 0}, Sag)
        Kose(Satir, 10)

        local Nk = Yeni("Frame", {Position = UDim2.fromOffset(28, Y + 6), Size = UDim2.fromOffset(10, 10),
            BackgroundColor3 = Renk, BorderSizePixel = 0}, Sag)
        Kose(Nk, 5)

        local _, Oturum, Toplam = Sutunlar(Sag, Y, P.Ad, (P.Sans and P.Sans > 0) and ("1/" .. KisaSayi(100 / P.Sans)) or "?",
            "+0", "0", Renk, (P.Sans and P.Sans < 0.001) and Enum.Font.GothamBold or Enum.Font.Gotham)

        PetSatirlari[P.Ad] = {Oturum = Oturum, Toplam = Toplam}
    end

    -- ALT BILGI
    Yazi(Ekran, {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -10), Size = UDim2.fromOffset(900, 22),
        TextSize = 14, TextColor3 = R.Soluk, TextXAlignment = Enum.TextXAlignment.Center,
        Text = Ayarlar.PanelTus .. " to hide / show"
            .. (Ayarlar.PanelRenderKapat and ("   •   3D rendering off + " .. tostring(Ayarlar.PanelFPS or 20) .. " fps cap while open (saves CPU / GPU)") or "")})

    ------------------------------------------------------------
    -- KUCUK PANEL (boss fight sirasinda)
    ------------------------------------------------------------
    local Mini = Yeni("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -16, 0.55, 0), Size = UDim2.fromOffset(280, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = R.Arka, BackgroundTransparency = 0.15, BorderSizePixel = 0,
        Active = false, Visible = false}, Gui)
    Kose(Mini, 12)
    Kenar(Mini, R.Turuncu, 1.5, 0.3)
    Yeni("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14)}, Mini)
    local MiniL = Yazi(Mini, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextSize = 15,
        TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, LineHeight = 1.2, Text = ""})

    ------------------------------------------------------------
    -- GIZLE / GOSTER
    ------------------------------------------------------------
    local function Buton(Metin, Gen, Ebeveyn)
        local B = Yeni("TextButton", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 14), Size = UDim2.fromOffset(Gen, 36),
            BackgroundColor3 = R.Kart2, BorderSizePixel = 0, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = R.Yazi,
            Text = Metin, AutoButtonColor = true}, Ebeveyn)
        Kose(B, 8)
        Kenar(B, R.Turuncu, 1.5, 0.3)
        return B
    end

    local Gizle = Buton("Hide  [" .. Ayarlar.PanelTus .. "]", 170, Ekran)
    local Ac = Buton("Show panel  [" .. Ayarlar.PanelTus .. "]", 190, Gui)
    Ac.Visible = false

    local ElleGizli = false
    local function Degistir() ElleGizli = not ElleGizli end
    Gizle.MouseButton1Click:Connect(Degistir)
    Ac.MouseButton1Click:Connect(Degistir)

    local TusOk, Tus = pcall(function() return Enum.KeyCode[Ayarlar.PanelTus] end)
    Tus = TusOk and Tus or Enum.KeyCode.RightShift
    UIS.InputBegan:Connect(function(I, Islendi)
        if not Islendi and I.KeyCode == Tus then Degistir() end
    end)

    local Render = true
    local function RenderAyarla(Acik)
        if Render == Acik then return end
        Render = Acik
        pcall(function() RunS:Set3dRenderingEnabled(Acik) end)
    end

    -- panel acikken fps'i dusur; boss fight'ta tap / baloncuk hizi dusmesin diye normal fps
    local Fps
    local function FpsAyarla(Yeni_)
        if Fps == Yeni_ then return end
        Fps = Yeni_
        pcall(function() setfpscap(Yeni_) end)
    end

    Gui.Destroying:Connect(function() RenderAyarla(true) FpsAyarla(Ayarlar.NormalFPS or 60) end)

    ------------------------------------------------------------
    -- GUNCELLEME
    ------------------------------------------------------------
    local SonHata = {}
    local function HataYaz(Yer, Hata)
        Hata = tostring(Hata)
        if SonHata[Yer] ~= Hata then
            SonHata[Yer] = Hata
            warn(("[Panel] %s hatasi: %s"):format(Yer, Hata))
        end
    end

    local HatchDeger = 0

    task.spawn(function()
        task.wait() -- kurulumu bekletme
        while Gui.Parent and Aktif() do
            local Ok1, E1 = pcall(PetleriSay)
            if not Ok1 then HataYaz("pet sayimi", E1) end

            local Ok2, E2 = pcall(HatchSayaci)
            if not Ok2 then HataYaz("hatch sayaci", E2) elseif E2 then HatchDeger = E2 end

            task.wait(10)
        end
    end)

    task.spawn(function()
        task.wait() -- kurulumu bekletme
        print("[Panel] guncelleme basladi.")

        while Gui.Parent and Aktif() do
            local Ok, Hata = pcall(function()
                local Fight = FightAktif()
                local Kucuk = Fight and Ayarlar.PanelFightKucuk == true

                Ekran.Visible = not ElleGizli and not Kucuk
                Mini.Visible = not ElleGizli and Kucuk
                Ac.Visible = ElleGizli
                RenderAyarla(not (Ayarlar.PanelRenderKapat and Ekran.Visible))
                FpsAyarla((Ayarlar.PanelRenderKapat and Ekran.Visible and not Fight) and (Ayarlar.PanelFPS or 20) or (Ayarlar.NormalFPS or 60))

                local Gecen = os.clock() - Istat.Baslangic
                local Dakika = math.max(Gecen / 60, 1 / 60)
                local Biten = Istat.Kazanilan + Istat.Kaybedilen
                local Oran = Biten > 0 and math.floor(Istat.Kazanilan / Biten * 100 + 0.5) or 0
                local Huge, Titan = OturumToplam(HugeMi), OturumToplam(TitanicMi)

                local EggToplam = math.max(Istat.Egg, HatchDeger)

                if Kucuk then
                    MiniL.Text = ("<b><font color=\"#ff8c28\">BOSS FIGHT #%d</font></b>\n%s won  •  %s lost\nWin rate: %d%%\nEggs: %s  •  Huge: %d  •  Titanic: %d"):format(
                        Istat.Fight, ("<font color=\"#64e187\">%d</font>"):format(Istat.Kazanilan),
                        ("<font color=\"#ff6969\">%d</font>"):format(Istat.Kaybedilen), Oran, KisaSayi(EggToplam), Huge, Titan)
                end

                if not Ekran.Visible then return end

                SureL.Text = SaatYaz(Gecen)
                DurumL.Text = tostring(Durum)

                EggL.Text = KisaSayi(EggToplam)
                EggAlt.Text = ("~%s per hour"):format(KisaSayi(EggToplam / Dakika * 60))
                EggDkL.Text = ("%.0f"):format(EggToplam / Dakika)
                EggDkAlt.Text = ("%s per hatch"):format(tostring(Ayarlar.HatchAdet or CalisanAdet or "?"))
                BossL.Text = tostring(Istat.Kazanilan)
                BossAlt.Text = ("%d fights  •  %d flame runs"):format(Istat.Fight, Istat.Seri)
                OranL.Text = Biten > 0 and ("%d%%"):format(Oran) or "-"
                OranAlt.Text = ("%d won / %d lost"):format(Istat.Kazanilan, Istat.Kaybedilen)
                HugeL.Text = tostring(Huge)
                HugeAlt.Text = "this session"
                TitanL.Text = tostring(Titan)
                TitanAlt.Text = "this session"
                OrbL.Text = KisaSayi(ToplamOrb)
                OrbAlt.Text = ("~%.0f per minute"):format(ToplamOrb / Dakika)
                CoinL.Text = KisaSayi(CoinOku())
                CoinAlt.Text = Ayarlar.CoinEgg and ("hatches at %s"):format(KisaSayi(Ayarlar.CoinUst)) or "coin hatching off"

                -- orb deposu
                local Su, Max = Depo()
                if Su and Max and Max > 0 then
                    OrbBar.Size = UDim2.fromScale(math.clamp(Su / Max, 0, 1), 1)
                    OrbBarL.Text = ("%s / %s  (%d%%)"):format(KisaSayi(Su), KisaSayi(Max), math.floor(Su / Max * 100))
                else
                    OrbBarL.Text = SayacLabel and SayacLabel.Text or "?"
                end

                -- luck flame (oyundaki flame yazilarindan; okunamazsa zamanlayicidan)
                local Hedef = Ayarlar.BossSeriSayisi or 3
                local Flame = FlameDurumu()
                local HedefF = Flame and Flame[Hedef]

                if not Ayarlar.BossSeri then
                    FlameBar.Size = UDim2.fromScale(0, 1)
                    FlameBarL.Text = "boss runs off"
                elseif HedefF then
                    local Yanik = YanikSayisi(Flame)
                    if HedefF.Yanik and HedefF.Kalan then
                        FlameBar.Size = UDim2.fromScale(math.clamp(HedefF.Kalan / FlameSure(), 0, 1), 1)
                        FlameBarL.Text = ("Flame %d lit  •  %s left"):format(Hedef, SureYaz(HedefF.Kalan))
                    else
                        FlameBar.Size = UDim2.fromScale(math.clamp(Yanik / Hedef, 0, 1), 1)
                        FlameBarL.Text = HedefF.Yanik and ("Flame %d lit"):format(Hedef) or ("%d / %d flames lit"):format(Yanik, Hedef)
                    end
                else
                    local Kalan = SonrakiSeri - os.clock()
                    FlameBar.Size = UDim2.fromScale(Kalan > 0 and math.clamp(Kalan / FlameSure(), 0, 1) or 0, 1)
                    FlameBarL.Text = Kalan > 0 and ("%s left  •  then next run"):format(SureYaz(Kalan)) or "next run due"
                end

                -- son cikanlar
                if #SonCikanlar > 0 then
                    local Satirlar = {}
                    for _, C in ipairs(SonCikanlar) do
                        local Renk = TitanicMi(C.Ad) and "#ffcd50" or HugeMi(C.Ad) and "#be78ff" or "#5aaaff"
                        table.insert(Satirlar, ("<font color=\"%s\"><b>%s</b></font>%s   <font color=\"#968faf\">%s ago</font>"):format(
                            Renk, C.Ad, C.Adet > 1 and (" x" .. C.Adet) or "", SureYaz(os.clock() - C.Zaman)))
                    end
                    AkisL.Text = table.concat(Satirlar, "\n")
                else
                    AkisL.Text = "<font color=\"#968faf\">no rare hatches yet (Huges, Titanics and pets rarer than 1/100k show up here)</font>"
                end

                -- pet tablosu
                for Ad, S in pairs(PetSatirlari) do
                    local Yeni_ = OturumAdet(Ad)
                    S.Oturum.Text = Yeni_ > 0 and ("+" .. KisaSayi(Yeni_)) or "+0"
                    S.Oturum.TextColor3 = Yeni_ > 0 and R.Yesil or R.Soluk
                    S.Toplam.Text = KisaSayi(PetSimdi[Ad] or 0)
                end
            end)

            if not Ok then HataYaz("guncelleme", Hata) end

            task.wait(0.5)
        end

        RenderAyarla(true)
        FpsAyarla(Ayarlar.NormalFPS or 60)
    end)
end

do
    local Ok, Hata = pcall(PanelKur)
    if not Ok then warn("[Panel] kurulamadi: " .. tostring(Hata)) end
end

----------------------------------------------------------------
-- TIKLAYARAK FARM: arka planda en yakin breakable'a vur
-- (oyun breakable'a tiklayinca Breakables_PlayerDealDamage("<breakable id>") gonderiyor)
----------------------------------------------------------------
if Ayarlar.TiklaFarm then
    task.spawn(function()
        local Remote = ReplicatedStorage:WaitForChild("Network"):FindFirstChild("Breakables_PlayerDealDamage")

        if not Remote then
            warn("[Click] 'Breakables_PlayerDealDamage' bulunamadi; tiklayarak farm kapali.")
            return
        end

        print(("[Click] tiklayarak farm acik: saniyede %.0f vurus, %d stud menzil."):format(
            1 / math.max(Ayarlar.TiklaAraligi, 0.01), Ayarlar.TiklaMesafe))

        local Hedef
        local Vurus, SonRapor = 0, os.clock()

        local function EnYakin(Pos)
            local T = Things()
            local Klasor = T and T:FindFirstChild("Breakables")
            local En, EnMesafe

            for _, B in ipairs(Klasor and Klasor:GetChildren() or {}) do
                local P = ObjPos(B)

                if P then
                    local M = (P - Pos).Magnitude
                    if M <= Ayarlar.TiklaMesafe and (not EnMesafe or M < EnMesafe) then
                        En, EnMesafe = B, M
                    end
                end
            end

            return En
        end

        while Aktif() do
            local HRP = Root()

            -- boss fight'ta tiklama baloncuk / tap'e karismasin
            if HRP and not FightAktif() then
                -- hedef kirildiysa ya da menzilden ciktiysa yenisini sec
                local HedefPos = Hedef and Hedef.Parent and ObjPos(Hedef)

                if not HedefPos or (HedefPos - HRP.Position).Magnitude > Ayarlar.TiklaMesafe then
                    Hedef = EnYakin(HRP.Position)
                end

                if Hedef then
                    local Id = Hedef.Name
                    pcall(function() Remote:FireServer(Id) end)
                    Vurus += 1
                end
            end

            if os.clock() - SonRapor >= 120 then
                print(("[Click] son 2 dk: %d vurus"):format(Vurus))
                Vurus, SonRapor = 0, os.clock()
            end

            task.wait(Ayarlar.TiklaAraligi)
        end
    end)
end

----------------------------------------------------------------
-- CPU / RAM TASARRUFU
-- CPU: en dusuk grafik, sesler kapali, golge / dekor kapali. (3D cizim + fps siniri panelde;
--      panel kapaliysa burada uygulanir, boss fight'ta normale doner.)
-- RAM: doku / dekal / parcacik / efekt / diger oyuncu karakterleri silinir.
--      Script'in kullandigi seylere (orb, breakable, egg, flame yazilari, pumpkin) dokunulmaz.
----------------------------------------------------------------
do
    local Lighting = game:GetService("Lighting")
    local RunS = game:GetService("RunService")

    if Ayarlar.CPUSaver then
        local Yapilan = {}

        if pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end) then
            table.insert(Yapilan, "grafik=1")
        end

        if pcall(function() UserSettings():GetService("UserGameSettings").MasterVolume = 0 end) then
            table.insert(Yapilan, "ses kapali")
        end

        pcall(function()
            Lighting.GlobalShadows = false
            local Terrain = workspace:FindFirstChildOfClass("Terrain")
            if Terrain then
                Terrain.Decoration = false
                Terrain.WaterWaveSize, Terrain.WaterWaveSpeed = 0, 0
            end
            table.insert(Yapilan, "golge / dekor kapali")
        end)

        -- panel kapaliysa 3D cizim + fps siniri burada (fight'ta normal)
        if not Ayarlar.Panel then
            table.insert(Yapilan, ("3D kapali + %d fps"):format(Ayarlar.PanelFPS or 20))

            task.spawn(function()
                local SonDurum

                while Aktif() do
                    local Fight = FightAktif()

                    if SonDurum ~= Fight then
                        SonDurum = Fight
                        pcall(function() RunS:Set3dRenderingEnabled(Fight) end)
                        pcall(function() setfpscap(Fight and (Ayarlar.NormalFPS or 60) or (Ayarlar.PanelFPS or 20)) end)
                    end

                    task.wait(0.5)
                end

                pcall(function() RunS:Set3dRenderingEnabled(true) end)
                pcall(function() setfpscap(Ayarlar.NormalFPS or 60) end)
            end)
        end

        print("[CPU] tasarruf acik: " .. table.concat(Yapilan, ", "))
    end

    if Ayarlar.RamSaver then
        task.spawn(function()
            local Sil = {
                Decal = true, Texture = true, ParticleEmitter = true, Trail = true, Beam = true, Fire = true,
                Smoke = true, Sparkles = true, SurfaceAppearance = true, Highlight = true,
            }

            -- script'in kullandigi yerler: dokunma
            local function Korunan(Obj)
                local T = Things()
                local Debris = workspace:FindFirstChild("__DEBRIS")

                for _, Kok in ipairs({
                    T and T:FindFirstChild("Breakables"),
                    T and T:FindFirstChild("CustomEggs"),
                    Debris and Debris:FindFirstChild("HatchWarOrbs"),
                    LocalPlayer.Character,
                }) do
                    if Kok and Obj:IsDescendantOf(Kok) then return true end
                end

                return false
            end

            local Silinen, Doku = 0, 0

            local function Temizle(Obj)
                local Sinif = Obj.ClassName

                if Sil[Sinif] then
                    if not Korunan(Obj) then
                        Silinen += 1
                        Obj:Destroy()
                    end
                elseif Sinif == "MeshPart" and Obj.TextureID ~= "" and not Korunan(Obj) then
                    Doku += 1
                    Obj.TextureID = ""
                elseif Ayarlar.RamSaverAgresif and Obj:IsA("Sound") then
                    Silinen += 1
                    Obj:Destroy()
                end
            end

            local Sayi = 0
            for _, Obj in ipairs(workspace:GetDescendants()) do
                if not Aktif() then return end
                pcall(Temizle, Obj)
                Sayi += 1
                if Sayi % 400 == 0 then task.wait() end
            end

            -- sonradan gelenler (yeni zone / efektler)
            local Baglanti = workspace.DescendantAdded:Connect(function(Obj)
                if Sil[Obj.ClassName] or Obj.ClassName == "MeshPart" or (Ayarlar.RamSaverAgresif and Obj:IsA("Sound")) then
                    task.defer(function()
                        if Obj.Parent then pcall(Temizle, Obj) end
                    end)
                end
            end)

            -- post-processing efektleri
            pcall(function()
                for _, E in ipairs(Lighting:GetChildren()) do
                    if E:IsA("PostEffect") or E:IsA("Atmosphere") or E:IsA("Clouds") or E:IsA("Sky") then E:Destroy() end
                end
            end)

            local function DigerOyunculariSil()
                for _, P in ipairs(Players:GetPlayers()) do
                    if P ~= LocalPlayer and P.Character then pcall(function() P.Character:Destroy() end) end
                end
            end

            local function AgresifTemizlik()
                local T = Things()
                -- sus esyalari / yerdeki ganimet gorselleri (script kullanmiyor)
                for _, Ad in ipairs({"Ornaments", "Lootbags", "Booths", "Hoverboards", "PetsHidden"}) do
                    local Klasor = T and T:FindFirstChild(Ad)
                    if Klasor then pcall(function() Klasor:ClearAllChildren() end) end
                end
            end

            DigerOyunculariSil()
            if Ayarlar.RamSaverAgresif then AgresifTemizlik() end

            task.wait(10)
            pcall(function() collectgarbage("collect") end)
            print(("[RAM] tasarruf acik: %d efekt silindi, %d model dokusu kaldirildi%s"):format(
                Silinen, Doku, Ayarlar.RamSaverAgresif and " (agresif)" or ""))

            while Aktif() do
                task.wait(60)
                DigerOyunculariSil()
                if Ayarlar.RamSaverAgresif then AgresifTemizlik() end
                pcall(function() collectgarbage("collect") end)
            end

            Baglanti:Disconnect()
        end)
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

    -- boss serisi (3 fight -> Luck Flame 3), flame bitince tekrar
    if BossSeriKontrol(Area) then continue end

    -- coin cok birikince (orb'dan bagimsiz) egg ac
    if Ayarlar.CoinEgg and CoinOku() >= Ayarlar.CoinUst then
        EggAc(Area, "coin")
        continue
    end

    -- depo dolu: boss fight (ya da egg). Fight'tan sonra hemen orb toplamaya donulur,
    -- depo tekrar dolunca yeni fight atilir (fight luck'i en yuksekken oynanir)
    if Ayarlar.OrbTopla ~= false and DepoDoluMu() then
        DoluIslemYap(Area)
        continue
    end

    local Orbs = Ayarlar.OrbTopla ~= false and Orblar(Area) or {}

    if #Orbs > 0 then
        Durum = ("Collecting orbs (%d)"):format(#Orbs)

        if OrblariTopla(Orbs) then
            DoluIslemYap(Area)
        end
    else
        -- orb yok: breakable'larin ortasinda bekle, pet'ler kirsin
        Durum = "Farming breakables"
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

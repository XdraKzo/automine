if not Settings or not LPH_OBFUSCATED then

    getgenv().Settings = {

        -- Keep this disabled: the combine/crafting section is not reliable in this version.
        CombineOres = false,

        -- true: mine every block in the latest unlocked zone, regardless of its ID.
        MineAllBlocks = false,

        -- MineAllBlocks + RevealMode: nadirlere hic bakmadan, karakterin menzilindeki BILINEN tum
        -- bloklari ustten alta kirar, katman katman asagi iner.
        -- Tek adimda kirilacak en fazla blok sayisi:
        ClearBatch = 64,

        -- Zigzag sirasi (MineAllBlocks): sutun sutun, tek sutun asagi / cift sutun yukari.
        -- Yanlis kosegen/yonden basliyorsa bunlari cevir:
        ZigzagSwapAxes = false,     -- true: sutunlar Z ekseninde, satirlar X ekseninde olur
        ZigzagInvertColumns = false, -- true: sutunlar ters uctan baslar (sol <-> sag)
        ZigzagInvertRows = false,    -- true: ilk sutun ters yonde baslar (yukari <-> asagi)

        -- Duracagi hucre (MineAllBlocks). Sutun/satir zigzag'daki gibi sayilir:
        -- 1. sutun = zigzag'in basladigi sutun, 1. satir = ilk sutunda basladigi uc.
        -- Cizimdeki mavi hucre: 8. sutun, 9. satir. nil birakirsan haritanin ortasi secilir.
        StandColumn = 8,
        StandRow = 9,

        -- Tam ekran istatistik paneli (CoreGui). false = kapali.
        ShowGUI = true,
        -- Paneli gizle / goster kisayol tusu (Enum.KeyCode adi).
        GUIToggleKey = "RightShift",
        -- Panel arka plan seffafligi: 0 = tam opak (tum ekran kaplanir), 1 = tamamen seffaf.
        GUIBackgroundTransparency = 0,

        -- Envanterdeki gemleri panelde goster (oyundaki display name ile).
        GUIShowGems = true,
        GUIGemClass = "Misc",
        -- Sadece EKRANDA GORUNEN ismi bu kelimelerden birini iceren esyalar gosterilir
        -- (ID'ye bakilmaz; eski etkinlik gemleri boylece elenir). Panelde bu sirayla dizilir.
        -- {} birakirsan asagidaki GUIGemMatch / GUIGemIDs kurali kullanilir.
        GUIGemNames = {"Moonstone", "Star Ruby", "Helium-3", "Nebulite", "Dark Matter"},
        GUIGemIDs = nil,
        GUIGemMatch = "gem",

        -- true: 15 sn'de bir konsola gem adetlerini 3 farkli kaynaktan (save / sayac / container) yazar.
        -- Envanter sayilari dogruysa false yapabilirsin.
        GUIInvDebug = true,
        -- true: adetleri ayrica oyunun kendi sayacindan (CountExact) okumayi dener.
        GUIUseCountExact = true,

        -- "Kirilan nadirler" kartlarindaki isimler. Bos birakirsan blok verisinden okunmaya calisilir.
        -- Elle vermek istersen: {Amethyst = "Dark Matter", Emerald = "Nebulite"} (blok ID = gorunen isim)
        OreDisplayNames = nil,

        -- Hizli kirma: her blok icin sabit +0.2sn bekleme ve tek tek onay beklemesi yok.
        -- Bloklari pes pese kirar, sonda toplu kontrol eder, kirilmayanlari tekrar dener.
        FastClear = true,
        -- Kirma suresinin ustune eklenen kucuk pay (sn). Script otomatik ayarlar:
        -- cok blok kirilamazsa artirir, hep basariliysa azaltir (alt sinir FastMarginMin).
        FastMargin = 0.06,
        FastMarginMin = 0.02,

        -- Bu kelimeleri ID'sinde iceren bloklar (buyuk/kucuk harf farketmez) KIRILANA KADAR beklenir,
        -- kirilamadi diye atlanmaz. {} = kapali.
        PersistentBlocks = {"Rainbow"},
        -- 0 = kirilana kadar sonsuza dek bekle. >0: bu kadar saniye sonra vazgec.
        PersistentMaxSeconds = 0,
        -- Her basarisiz turda bekleme suresi artar, en fazla bu kadar sn ekstra beklenir.
        PersistentMaxExtra = 6,

        -- true: haritayi alttan yukariya duraklarla gezip nadirleri kirar (onerilen).
        -- false: eski davranis (sadece yuklu en derin layer).
        -- true: sadece bilinen (yuklu) bloklarla calisir. Bilinen nadirleri en derinden baslayarak kirar,
        -- nadir kalmadiysa bilinen en derin blogu kirip asagiyi acar. (Onerilen)
        RevealMode = true,

        -- Saft kazarken tek adimda kac tur atilacagi (her turda her sutundan bir blok kirilir).
        DigBatch = 12,

        -- Ayni anda kac saft (sutun) birlikte kazilsin. Yuksek = daha hizli inis (menzil icinde kalanlar).
        ShaftColumns = 6,

        -- NADIR FARM MODU (MineAllBlocks = false): ID'sinde bu kelimeler gecen bloklar (Gold = Meteorite)
        -- KAZILMAZ / yanlari kirilmaz (nadir cikmiyor). Bilinen tum bloklar bunlardan ibaretse sadece
        -- tek bir sutunda DUMDUZ asagi kazilir; magma / obsidian katmanina inince normal saft kazma
        -- (etrafi acip nadirleri gorme) devam eder. {} = kapali.
        SkipBlocks = {"Gold"},
        -- Gold'dan sonra yan sutunlarin tepesi kapali oldugu icin: kuyunun cevresinde (bu kadar hucre
        -- yaricapta, ayni katmanda) bilinen bloklar da kirilip yandaki grid sutunlari acilir.
        ShaftOpenRadius = 3,

        -- Saftlar X ve Z'de bu aralikla acilir (2 = her 2 sutunda bir). 1 = tum sutunlar.
        -- Grid bitince kalan sutunlar da acilmaya devam eder.
        ShaftSpacing = 2,

        SweepBottomToTop = true,

        -- true: blok part'i yuklenmese bile World:GetBlock verisiyle kirar (chunk yukleme sorununu asar).
        MineWithoutPart = true,

        -- Sweep durak araligi (bos birakirsan MiningRange'e gore otomatik: 48 / 24)
        SweepStepXZ = nil,
        SweepStepY = nil,

        -- Used only when the current game version does not expose its mining damage calculator.
        FallbackBreakTime = 0,

        -- Height used while standing above the active mining layer.
        HoverHeight = 4,

        -- BlockWorlds mining remotes stop working at roughly 41 studs.
        MiningRange = 40,

        -- Maximum time to wait for a teleported ore area to stream in.
        StreamTimeout = 4,

        -- Small delay after the final exact ore alignment.
        TeleportSettleTime = 0.35,

        -- The script matches these values against Block.Dir._id exactly.
        -- When MineAllBlocks is false, this is the target whitelist.
        BlockPriority = {
            "Rainbow",
            "Amethyst",
            "Emerald",
            --"Ruby",
            --"Sapphire"
        },

        -- Leave false for the normal World.Blocks mining path.
        TargetDiamonds = false,

        Debug = {
            -- Keep false so the character can stand on the mining blocks.
            DisableUI = false,
            -- Per-block console output noticeably slows down fast mining.
            PrintMining = false,
        }
    }

end

Debug = Settings.Debug or {}

getgenv().Mining = {
    Blocks = {},
    ActiveLayerY = nil,
    ActiveStandPosition = nil,
    MinedPositions = {},
    FailedPositions = {}
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local PhysicsService = game:GetService("PhysicsService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer

if not game:IsLoaded() then
    game.Loaded:Wait()
end

repeat task.wait()
    LocalPlayer = Players.LocalPlayer
until LocalPlayer and LocalPlayer.GetAttribute and LocalPlayer:GetAttribute("__LOADED")

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local Character = LocalPlayer.Character
local HumanoidRootPart = Character.HumanoidRootPart
local NLibrary = ReplicatedStorage.Library
local Library = rawget(getgenv(), "Library")

if not Library then
    Library = require(NLibrary)
end

if Library.Loaded ~= nil then
    repeat task.wait() until Library.Loaded
end

local PlayerScripts = LocalPlayer.PlayerScripts.Scripts
local StartingTime = os.time()


function Mining.UpdateBlocks(InRange)
    if not InRange then
        -- (eski tam-liste yontemi devre disi)
    else
        local RegionMin = HumanoidRootPart.Position - Vector3.new(15, 15, 15)
        local RegionMax = HumanoidRootPart.Position + Vector3.new(15, 15, 15)
        local Region = Region3.new(RegionMin, RegionMax)
        local Parts = workspace:FindPartsInRegion3WithIgnoreList(Region, {Character}, 50)
        for _, Part in ipairs(Parts) do
            if Part.Parent.Parent == workspace.__THINGS.BlockWorlds then
                table.insert(Mining.Blocks, Part)
            end
        end
    end
end

local CachedMiningUtil;
local MiningUtilResolved = false

function Mining.GetMiningUtil()
    if CachedMiningUtil then return CachedMiningUtil end
    if MiningUtilResolved then return end
    MiningUtilResolved = true

    for Name, Module in pairs(Library) do
        if type(Module) == "table" and tostring(Name):lower():find("miningutil") then
            if Module.ComputeDamage and Module.ComputeSpeed then
                CachedMiningUtil = Module
                return Module
            end
        end
    end

    for _, Object in ipairs(NLibrary:GetDescendants()) do
        if Object:IsA("ModuleScript") and Object.Name:lower():find("miningutil") then
            local Success, Module = pcall(require, Object)
            if Success and type(Module) == "table" and Module.ComputeDamage and Module.ComputeSpeed then
                CachedMiningUtil = Module
                return Module
            end
        end
    end
end

local CachedNetwork;

function Mining.GetNetwork()
    if CachedNetwork then return CachedNetwork end

    local Visited = {}

    local function SearchTable(Container, Depth)
        if type(Container) ~= "table" or Visited[Container] or Depth > 3 then return end
        Visited[Container] = true

        if type(Container.Fire) == "function" then
            return Container
        end

        for Name, Value in pairs(Container) do
            if type(Value) == "table" then
                if tostring(Name):lower():find("network") and type(Value.Fire) == "function" then
                    return Value
                end
                local Found = SearchTable(Value, Depth + 1)
                if Found then return Found end
            end
        end
    end

    CachedNetwork = SearchTable(Library, 0)
    if CachedNetwork then return CachedNetwork end

    local Candidates = {}
    for _, Object in ipairs(NLibrary:GetDescendants()) do
        if Object:IsA("ModuleScript") and Object.Name:lower():find("network") then
            table.insert(Candidates, Object)
        end
    end

    table.sort(Candidates, function(A, B)
        return A.Name == "Network" and B.Name ~= "Network"
    end)

    for _, Object in ipairs(Candidates) do
        local Success, Module = pcall(require, Object)
        if Success and type(Module) == "table" and type(Module.Fire) == "function" then
            CachedNetwork = Module
            return Module
        end
    end
end

function Mining.GetBlockBreakTime(Block)
    local MiningUtil = Mining.GetMiningUtil()

    if not MiningUtil or not MiningUtil.GetSelectedPickaxe or not MiningUtil.GetBestPickaxe then
        return Settings.FallbackBreakTime or 0.05
    end

    local Success, BreakTime = pcall(function()
        local SelectedPickaxe = MiningUtil.GetSelectedPickaxe(LocalPlayer)
        local BestPickaxe = MiningUtil.GetBestPickaxe(LocalPlayer, true)

        if not SelectedPickaxe or not BestPickaxe then
            return Settings.FallbackBreakTime or 0.05
        end

        local BlockData = Block.GetDirectory and Block:GetDirectory() or Block.Dir
        local UserDamage = MiningUtil.ComputeDamage(LocalPlayer, SelectedPickaxe, BestPickaxe, BlockData)
        local UserSpeed = MiningUtil.ComputeSpeed(LocalPlayer, SelectedPickaxe)
        local DamagePerSecond = UserDamage * UserSpeed

        if not DamagePerSecond or DamagePerSecond <= 0 then
            return Settings.FallbackBreakTime or 0.05
        end

        return BlockData.Strength / DamagePerSecond
    end)

    if not Success or type(BreakTime) ~= "number" then
        return Settings.FallbackBreakTime or 0.05
    end

    return BreakTime
end

function Mining.GetInstancingCmds()
    if Library.InstancingCmds then
        return Library.InstancingCmds
    end

    -- Compatibility fallback for renamed instancing modules.
    for Name, Module in pairs(Library) do
        if type(Module) == "table" and tostring(Name):lower():find("instanc") then
            if Module.Get or Module.Enter or Module.GetInstanceID then
                return Module
            end
        end
    end

    for _, Object in ipairs(NLibrary:GetDescendants()) do
        if Object:IsA("ModuleScript") and Object.Name:lower():find("instanc") then
            local Success, Module = pcall(require, Object)
            if Success and type(Module) == "table" then
                if Module.Get or Module.Enter or Module.GetInstanceID then
                    return Module
                end
            end
        end
    end
end

function Mining.FindTeleports()
    local InstancingCmds = Mining.GetInstancingCmds()

    if InstancingCmds and InstancingCmds.Get then
        local Success, InstanceData = pcall(InstancingCmds.Get)
        if Success and InstanceData and InstanceData.model then
            local Teleports = InstanceData.model:FindFirstChild("Teleports")
            if Teleports then return Teleports end
        end
    end

    for _, Object in ipairs(workspace:GetDescendants()) do
        if Object.Name == "Teleports" then
            return Object
        end
    end
end

function Mining.GetBlockWorldClient()
    local DirectCandidateNames = {
        "BlockWorldClient",
        "BlockWorldsClient",
        "BlockWorldCmds",
    }

    for _, Name in ipairs(DirectCandidateNames) do
        local Module = Library[Name]
        if type(Module) == "table" and type(Module.GetLocal) == "function" then
            return Module
        end
    end

    for Name, Module in pairs(Library) do
        local LowerName = tostring(Name):lower()
        if LowerName:find("blockworld") and type(Module) == "table" and type(Module.GetLocal) == "function" then
            return Module
        end
    end

    for _, Object in ipairs(NLibrary:GetDescendants()) do
        if Object:IsA("ModuleScript") and Object.Name:lower():find("blockworld") then
            local Success, Module = pcall(require, Object)
            if Success and type(Module) == "table" and type(Module.GetLocal) == "function" then
                return Module
            end
        end
    end
end

function Mining.TeleportToZone(SpecificZone)
    local CurrentZone = SpecificZone

    if not CurrentZone and Library.InstanceZoneCmds and Library.InstanceZoneCmds.GetMaximumOwnedZoneNumber then
        CurrentZone = Library.InstanceZoneCmds.GetMaximumOwnedZoneNumber()
    end

    local Teleports = Mining.FindTeleports()

    if not Teleports then
        warn("[Mining] Teleports folder was not found; staying in the current zone.")
    else
        if not CurrentZone then
            for _, Pad in ipairs(Teleports:GetChildren()) do
                local ZoneNumber = tonumber(Pad.Name)
                if ZoneNumber and (not CurrentZone or ZoneNumber > CurrentZone) then
                    CurrentZone = ZoneNumber
                end
            end
        end

        local TeleportPad = CurrentZone and Teleports:FindFirstChild(tostring(CurrentZone))

        if TeleportPad then
            if TeleportPad:IsA("BasePart") then
                HumanoidRootPart.CFrame = TeleportPad.CFrame
            elseif TeleportPad:IsA("Model") then
                HumanoidRootPart.CFrame = TeleportPad:GetPivot()
            end
        else
            warn("[Mining] Teleport pad was not found; staying in the current zone.")
        end
    end

    local TimeoutAt = os.clock() + 30

    repeat
        local BlockWorldClient = Mining.GetBlockWorldClient()
        if BlockWorldClient then
            local Success, ActiveWorld = pcall(BlockWorldClient.GetLocal)
            if Success and ActiveWorld then
                World = ActiveWorld
                break
            end
        end
        task.wait(0.5)
    until os.clock() >= TimeoutAt

    if not World then
        error("[Mining] BlockWorld did not become active within 30 seconds. Enter the Mining Event manually, wait for the blocks to appear, then run the script.")
    end

    if not Settings.TargetDiamonds then
        Mining.UpdateBlocks()
    end
end

function Mining.EnterInstance(Name)
    local InstancingCmds = Mining.GetInstancingCmds()

    if not InstancingCmds then
        warn("[Mining] Instancing module is unavailable; assuming the player is already in the Mining Event.")
        return
    end

    if InstancingCmds.GetInstanceID and InstancingCmds.GetInstanceID() == Name then return end

    if not InstancingCmds.Enter then
        warn("[Mining] Instance entry function is unavailable; enter the Mining Event manually.")
        return
    end

    setthreadidentity(2)
    InstancingCmds.Enter(Name)
    setthreadidentity(8)

    if InstancingCmds.GetInstanceID then
        local TimeoutAt = os.clock() + 15
        repeat task.wait(0.25)
        until InstancingCmds.GetInstanceID() == Name or os.clock() >= TimeoutAt

        if InstancingCmds.GetInstanceID() ~= Name then
            warn("[Mining] Automatic event entry was not confirmed; waiting for an active BlockWorld.")
        end
    else
        task.wait(1)
    end
end

local RemoteCounter = 0

function Mining.MoveToBlock(Block)
    if not Block or not Block.CFrame then return end

    local Height = Settings.HoverHeight or 4

    HumanoidRootPart.CFrame = Block.CFrame + Vector3.new(0, Height, 0)
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    HumanoidRootPart.Anchored = false
end

function Mining.EnsureSupport(Position, Drop)
    if not Position then return end

    local Name = "MiningSupport_" .. tostring(LocalPlayer.UserId)
    local Support = Mining.SupportPart

    if not Support or not Support.Parent then
        Support = workspace:FindFirstChild(Name)
    end

    if not Support then
        Support = Instance.new("Part")
        Support.Name = Name
        Support.Size = Vector3.new(12, 1, 12)
        Support.Transparency = 1
        Support.Anchored = true
        Support.CanCollide = true
        Support.CanTouch = false
        Support.CanQuery = false
        Support.CastShadow = false
        Support.Parent = workspace
    end

    Support.CFrame = CFrame.new(Position - Vector3.new(0, Drop or 3.5, 0))
    Mining.SupportPart = Support
end

function Mining.RemoveSupport()
    local Name = "MiningSupport_" .. tostring(LocalPlayer.UserId)
    local Support = Mining.SupportPart or workspace:FindFirstChild(Name)

    if Support then Support:Destroy() end

    Mining.SupportPart = nil
end

function Mining.MoveToMiningPosition(Position)
    if not Position then return end

    Mining.EnsureSupport(Position)

    HumanoidRootPart.CFrame = CFrame.new(Position)
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    HumanoidRootPart.Anchored = false
end

function Mining.ResolveLiveBlock(Block)
    if not Block or not Block.Pos then return nil end

    local Success, CurrentBlock = pcall(function()
        return World:GetBlock(Block.Pos)
    end)

    if not Success or not CurrentBlock or not CurrentBlock.Part or
        not CurrentBlock.Part.Parent or not CurrentBlock.CFrame or not CurrentBlock.Dir then
        return nil
    end

    return CurrentBlock
end

function Mining.GetLayerIndex(Block)
    if Block and Block.Pos and Block.Pos.Y ~= nil then
        return Block.Pos.Y
    end

    return Block.CFrame.Position.Y
end

function Mining.GetPositionKey(Block)
    return Block and Block.Pos and tostring(Block.Pos) or nil
end

function Mining.RefreshBlock(Block)
    if not Block or not Block.Pos then return nil end

    local Success, CurrentBlock = pcall(function()
        return World:GetBlock(Block.Pos)
    end)

    if Success and CurrentBlock then
        return CurrentBlock
    end

    return Block
end

function Mining.IsBlockBroken(Block, TrackedPart)
    local Part = TrackedPart or (Block and Block.Part)
    return not Part or not Part.Parent
end

function Mining.MineOreReliable(Block)
    if Mining.IsPersistent and Mining.IsPersistent(Block) then
        return Mining.BreakPersistent(Block)
    end

    local PositionKey = Mining.GetPositionKey(Block)
    local TrackedPart = Block and Block.Part
    local Network = Mining.GetNetwork()

    if not Network then
        error("[Mining] Could not find the current Network module with a Fire function.")
    end

    for Attempt = 1, 3 do
        if Mining.IsBlockBroken(Block, TrackedPart) then
            if PositionKey then Mining.MinedPositions[PositionKey] = true end
            return true
        end

        Block = Mining.RefreshBlock(Block)

        if not Block or not Block.Part or not Block.Part.Parent or not Block.CFrame then
            return false
        end

        TrackedPart = Block.Part

        if (HumanoidRootPart.Position - Block.CFrame.Position).Magnitude >= 41 then
            return false
        end

        local BreakTime = Mining.GetBlockBreakTime(Block)

        Network.Fire("BlockWorlds_Target", Block.Pos, RemoteCounter, false)

        -- The server needs time to register the target even when damage time is zero.
        task.wait(math.max(BreakTime, 0) + 0.2)

        Network.Fire("BlockWorlds_Break", Block.Pos, RemoteCounter)
        RemoteCounter += 1

        local ConfirmUntil = os.clock() + 0.75

        repeat
            if Mining.IsBlockBroken(Block, TrackedPart) then
                if PositionKey then Mining.MinedPositions[PositionKey] = true end
                if Mining.CountBreak then Mining.CountBreak(Block) end
                return true
            end
            task.wait(0.05)
        until os.clock() >= ConfirmUntil

        -- Keep the character exactly aligned for the retry.
        Mining.MoveToMiningPosition(Block.CFrame.Position + Vector3.new(0, Settings.HoverHeight or 4, 0))
        task.wait(0.15)
    end

    return false
end

function Mining.MoveToAndLoadOre(Block)
    Block = Mining.RefreshBlock(Block)

    if not Block or not Block.CFrame then return nil end

    local SafeCFrame = HumanoidRootPart.CFrame
    local Height = Settings.HoverHeight or 4
    local TargetPosition = Block.CFrame.Position + Vector3.new(0, Height, 0)
    local StreamTimeout = Settings.StreamTimeout or 4

    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    Mining.EnsureSupport(HumanoidRootPart.Position)
    HumanoidRootPart.Anchored = false

    local function RequestArea(Position)
        task.spawn(function()
            pcall(function()
                LocalPlayer:RequestStreamAroundAsync(Position, StreamTimeout)
            end)
        end)
    end

    local function WaitForLoadedOre(Timeout)
        local TimeoutAt = os.clock() + Timeout

        repeat
            local CurrentBlock = Mining.RefreshBlock(Block)
            if CurrentBlock and CurrentBlock.CFrame and CurrentBlock.Part and CurrentBlock.Part.Parent then
                return CurrentBlock
            end
            task.wait(0.1)
        until os.clock() >= TimeoutAt

        return nil
    end

    -- First ask Roblox to stream the ore while staying at the known-safe position.
    RequestArea(Block.CFrame.Position)

    local CurrentBlock = WaitForLoadedOre(math.min(1.5, StreamTimeout))

    if not CurrentBlock then
        Mining.MoveToMiningPosition(TargetPosition)
        RequestArea(Block.CFrame.Position)
        CurrentBlock = WaitForLoadedOre(StreamTimeout)
    end

    if not CurrentBlock then
        HumanoidRootPart.CFrame = SafeCFrame
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        Mining.EnsureSupport(SafeCFrame.Position)
        HumanoidRootPart.Anchored = false
        return nil
    end

    local ExactPosition = CurrentBlock.CFrame.Position + Vector3.new(0, Height, 0)

    Mining.MoveToMiningPosition(ExactPosition)
    task.wait(Settings.TeleportSettleTime or 0.35)

    CurrentBlock = Mining.RefreshBlock(CurrentBlock)

    if CurrentBlock and CurrentBlock.Part and CurrentBlock.Part.Parent and CurrentBlock.CFrame and
        (HumanoidRootPart.Position - CurrentBlock.CFrame.Position).Magnitude < 41 then
        return CurrentBlock
    end

    HumanoidRootPart.CFrame = SafeCFrame
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    Mining.EnsureSupport(SafeCFrame.Position)
    HumanoidRootPart.Anchored = false

    return nil
end

function Mining.GetDeepestPriorityOres()
    local Region = World:GetRegion()
    local DeepestLayer = -math.huge
    local Ores = {}
    local Seen = {}

    local function Consider(Block)
        if not Block or not Block.Pos or not Block.CFrame or not Block.Dir or
            not Settings.BlockPriority[Block.Dir._id] then
            return
        end

        local PositionKey = Mining.GetPositionKey(Block)

        if not PositionKey or Seen[PositionKey] or Mining.MinedPositions[PositionKey] then return end
        if Mining.FailedPositions[PositionKey] and Mining.FailedPositions[PositionKey] > os.clock() then return end

        Seen[PositionKey] = true

        local Layer = Mining.GetLayerIndex(Block)

        if Layer > DeepestLayer then
            DeepestLayer = Layer
            Ores = {Block}
        elseif Layer == DeepestLayer then
            table.insert(Ores, Block)
        end
    end

    -- Direct region access sees ores even when their visual parts are not streamed yet.
    for y = Region.Max.Y, Region.Min.Y, -2 do
        for x = Region.Min.X, Region.Max.X, 3 do
            for z = Region.Min.Z, Region.Max.Z, 3 do
                local Success, Block = pcall(function()
                    return World:GetBlock(Vector3int16.new(x, y, z))
                end)
                if Success then Consider(Block) end
            end
        end
        if #Ores > 0 then break end
    end

    -- Merge currently streamed blocks in case their grid offset is not hit by the scan stride.
    for _, Block in pairs(World.Blocks) do
        Consider(Block)
    end

    table.sort(Ores, function(a, b)
        local PriorityA = Settings.BlockPriority[a.Dir._id] or math.huge
        local PriorityB = Settings.BlockPriority[b.Dir._id] or math.huge

        if PriorityA == PriorityB then
            return (a.CFrame.Position - HumanoidRootPart.Position).Magnitude <
                (b.CFrame.Position - HumanoidRootPart.Position).Magnitude
        end

        return PriorityA < PriorityB
    end)

    return Ores, DeepestLayer
end

function Mining.PriorityOreMining()
    local Ores = Mining.GetDeepestPriorityOres()

    if #Ores == 0 then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        Mining.EnsureSupport(HumanoidRootPart.Position)
        HumanoidRootPart.Anchored = false
        task.wait(0.25)
        return
    end

    local PrimaryOre = Mining.MoveToAndLoadOre(Ores[1])

    if not PrimaryOre then
        local FailedKey = Mining.GetPositionKey(Ores[1])
        if FailedKey then Mining.FailedPositions[FailedKey] = os.clock() + 2 end
        task.wait(0.25)
        return
    end

    local PrimaryKey = Mining.GetPositionKey(PrimaryOre)
    if PrimaryKey then Mining.FailedPositions[PrimaryKey] = nil end

    local PrimaryBroken = Mining.MineOreReliable(PrimaryOre)

    if not PrimaryBroken then
        return
    end

    for Index = 2, #Ores do
        local Ore = Mining.RefreshBlock(Ores[Index])

        if Ore and Ore.Part and Ore.Part.Parent and Ore.CFrame and
            (HumanoidRootPart.Position - Ore.CFrame.Position).Magnitude < 41 then
            local OreBroken = Mining.MineOreReliable(Ore)
            if not OreBroken then return end
        end
    end

    task.wait(0.2)
end

----------------------------------------------------------------
-- BOTTOM-TO-TOP SWEEP
----------------------------------------------------------------

-- BlockToWorldPos yoksa, yuklu iki bloktan grid -> world olcegini cikarir
function Mining.GetGridRef()
    if Mining.GridRef then return Mining.GridRef end

    local First
    local Scale = {}

    for _, Block in pairs(World.Blocks) do
        if Block and Block.Pos and Block.CFrame then
            if not First then
                First = Block
            else
                local dw = Block.CFrame.Position - First.CFrame.Position
                local gx = Block.Pos.X - First.Pos.X
                local gy = Block.Pos.Y - First.Pos.Y
                local gz = Block.Pos.Z - First.Pos.Z

                if gx ~= 0 then Scale.X = dw.X / gx end
                if gy ~= 0 then Scale.Y = dw.Y / gy end
                if gz ~= 0 then Scale.Z = dw.Z / gz end

                if Scale.X and Scale.Y and Scale.Z then
                    Mining.GridRef = {Block = First, Scale = Scale}
                    return Mining.GridRef
                end
            end
        end
    end
end

function Mining.GridToWorld(X, Y, Z)
    if World.BlockToWorldPos then
        local Ok, Result = pcall(function()
            return World:BlockToWorldPos(Vector3int16.new(X, Y, Z))
        end)
        if Ok and typeof(Result) == "Vector3" then return Result end
    end

    local Ref = Mining.GetGridRef()

    if Ref then
        local P = Ref.Block.Pos
        return Ref.Block.CFrame.Position + Vector3.new(
            (X - P.X) * Ref.Scale.X,
            (Y - P.Y) * Ref.Scale.Y,
            (Z - P.Z) * Ref.Scale.Z
        )
    end
end

local function SweepAxis(Min, Max, Step)
    local List = {}
    local V = Min + Step / 2

    while V < Max + Step / 2 do
        local Clamped = math.min(V, Max)
        if #List == 0 or Clamped - List[#List] > 1 then
            table.insert(List, Clamped)
        end
        V += Step
    end

    if #List == 0 then List[1] = (Min + Max) / 2 end

    return List
end

-- Tum haritayi kapsayan durak listesi: en alttan yukariya
function Mining.BuildSweepPlan()
    local Region = World:GetRegion()
    local A = Mining.GridToWorld(Region.Min.X, Region.Min.Y, Region.Min.Z)
    local B = Mining.GridToWorld(Region.Max.X, Region.Max.Y, Region.Max.Z)

    if not A or not B then return nil end

    local MinV = Vector3.new(math.min(A.X, B.X), math.min(A.Y, B.Y), math.min(A.Z, B.Z))
    local MaxV = Vector3.new(math.max(A.X, B.X), math.max(A.Y, B.Y), math.max(A.Z, B.Z))

    local Range = Settings.MiningRange or 40
    local StepXZ = Settings.SweepStepXZ or math.floor(Range * 1.2)
    local StepY = Settings.SweepStepY or math.floor(Range * 0.6)

    local XList = SweepAxis(MinV.X, MaxV.X, StepXZ)
    local ZList = SweepAxis(MinV.Z, MaxV.Z, StepXZ)
    local YList = SweepAxis(MinV.Y, MaxV.Y, StepY) -- artan Y = alttan yukari

    local Plan = {}

    for LevelIndex, Y in ipairs(YList) do
        for ColIndex, X in ipairs(XList) do
            local Flip = (LevelIndex + ColIndex) % 2 == 0
            for k = 1, #ZList do
                local Z = Flip and ZList[#ZList - k + 1] or ZList[k]
                table.insert(Plan, Vector3.new(X, Y, Z))
            end
        end
    end

    return Plan
end

function Mining.LoadAround(Position)
    pcall(function()
        LocalPlayer:RequestStreamAroundAsync(Position, Settings.StreamTimeout or 4)
    end)
end

-- Duragin 40 stud cevresindeki tum hedef nadirleri topla
function Mining.CollectOresAround(Stand)
    local Range = Settings.MiningRange or 40
    local Ores, Seen = {}, {}

    local function Consider(Block)
        if not Block or not Block.Pos or not Block.CFrame or not Block.Dir then return end
        if not Settings.BlockPriority[Block.Dir._id] then return end

        local Key = Mining.GetPositionKey(Block)

        if not Key or Seen[Key] or Mining.MinedPositions[Key] then return end
        if Mining.FailedPositions[Key] and Mining.FailedPositions[Key] > os.clock() then return end
        if (Block.CFrame.Position - Stand).Magnitude > Range - 1 then return end

        Seen[Key] = true
        table.insert(Ores, Block)
    end

    -- 1) su an yuklu olanlar
    for _, Block in pairs(World.Blocks) do Consider(Block) end

    -- 2) duragin cevresindeki grid kutusunu direkt tara
    local Region = World:GetRegion()

    local Ok, Lo, Hi = pcall(function()
        return World:WorldToBlockPos(Stand - Vector3.new(Range, Range, Range)),
               World:WorldToBlockPos(Stand + Vector3.new(Range, Range, Range))
    end)

    if Ok and Lo and Hi then
        local SX, SY, SZ = 3, 2, 3 -- orijinal scriptteki stride'lar

        local function Snap(V, Min, Step)
            return Min + math.ceil((V - Min) / Step) * Step
        end

        local x0 = math.max(math.min(Lo.X, Hi.X), Region.Min.X)
        local x1 = math.min(math.max(Lo.X, Hi.X), Region.Max.X)
        local y0 = math.max(math.min(Lo.Y, Hi.Y), Region.Min.Y)
        local y1 = math.min(math.max(Lo.Y, Hi.Y), Region.Max.Y)
        local z0 = math.max(math.min(Lo.Z, Hi.Z), Region.Min.Z)
        local z1 = math.min(math.max(Lo.Z, Hi.Z), Region.Max.Z)

        for y = Snap(y0, Region.Min.Y, SY), y1, SY do
            for x = Snap(x0, Region.Min.X, SX), x1, SX do
                for z = Snap(z0, Region.Min.Z, SZ), z1, SZ do
                    local Success, Block = pcall(function()
                        return World:GetBlock(Vector3int16.new(x, y, z))
                    end)
                    if Success then Consider(Block) end
                end
            end
        end
    end

    -- en alttaki once, sonra BlockPriority sirasi, sonra yakinlik
    table.sort(Ores, function(a, b)
        local ya = math.floor(a.CFrame.Position.Y + 0.5)
        local yb = math.floor(b.CFrame.Position.Y + 0.5)

        if ya ~= yb then return ya < yb end

        local pa = Settings.BlockPriority[a.Dir._id] or math.huge
        local pb = Settings.BlockPriority[b.Dir._id] or math.huge

        if pa ~= pb then return pa < pb end

        return (a.CFrame.Position - Stand).Magnitude < (b.CFrame.Position - Stand).Magnitude
    end)

    return Ores
end

----------------------------------------------------------------
-- REVEAL MODE: bilinen nadirleri en derinden kir, yoksa asagiyi ac
----------------------------------------------------------------
function Mining.GetKnownBlocks()
    local List = {}

    for _, Block in pairs(World.Blocks) do
        if Block and Block.Part and Block.Part.Parent and Block.CFrame and Block.Dir and Block.Pos then
            local Key = Mining.GetPositionKey(Block)

            if Key and not Mining.MinedPositions[Key] and
                not (Mining.FailedPositions[Key] and Mining.FailedPositions[Key] > os.clock()) then
                table.insert(List, Block)
            end
        end
    end

    return List
end

Mining.Unbreakable = Mining.Unbreakable or {}
Mining.FailCount = Mining.FailCount or {}
Mining.DoneColumns = Mining.DoneColumns or {}
Mining.CurrentShaft = nil

local function ColumnKey(Block)
    return tostring(Block.Pos.X) .. "," .. tostring(Block.Pos.Z)
end

local function IsPatternColumn(Pos)
    local N = Settings.ShaftSpacing or 2
    if N <= 1 then return true end
    return (Pos.X % N == 0) and (Pos.Z % N == 0)
end

-- Hic kirilamayan blok turlerini (bedrock vb.) ogrenip atlar
function Mining.NoteBreak(Block, Success)
    local Id = Block.Dir and Block.Dir._id
    if not Id or Settings.BlockPriority[Id] or (Mining.IsPersistent and Mining.IsPersistent(Block)) then return end

    local Count = Mining.FailCount[Id]
    if not Count then
        Count = {Ok = 0, Fail = 0}
        Mining.FailCount[Id] = Count
    end

    if Success then
        Count.Ok += 1
        Count.Fail = 0
    else
        Count.Fail += 1
    end

    if Count.Ok == 0 and Count.Fail >= 3 and not Mining.Unbreakable[Id] then
        Mining.Unbreakable[Id] = true
        warn("[Reveal] '" .. tostring(Id) .. "' kirilamiyor gibi, artik atlanacak.")
    end
end

function Mining.MineKnownOres(Ores, KnownCount)
    local Range = Settings.MiningRange or 40

    -- en derin (dunya Y'si en dusuk) once, sonra BlockPriority sirasi, sonra yakinlik
    table.sort(Ores, function(a, b)
        local La = math.floor(a.CFrame.Position.Y / 5 + 0.5)
        local Lb = math.floor(b.CFrame.Position.Y / 5 + 0.5)

        if La ~= Lb then return La < Lb end

        local Pa = Settings.BlockPriority[a.Dir._id] or math.huge
        local Pb = Settings.BlockPriority[b.Dir._id] or math.huge

        if Pa ~= Pb then return Pa < Pb end

        return (a.CFrame.Position - HumanoidRootPart.Position).Magnitude <
            (b.CFrame.Position - HumanoidRootPart.Position).Magnitude
    end)

    local Target = Ores[1]

    Mining.StepCount = (Mining.StepCount or 0) + 1

    if Mining.StepCount % 5 == 1 or Debug.PrintMining then
        print(("[Reveal] NADIR | bilinen=%d nadir=%d | hedef=%s Y=%.0f"):format(
            KnownCount, #Ores, tostring(Target.Dir._id), Target.CFrame.Position.Y))
    end

    if (HumanoidRootPart.Position - Target.CFrame.Position).Magnitude > Range - 8 then
        Mining.MoveToMiningPosition(Target.CFrame.Position + Vector3.new(0, Settings.HoverHeight or 4, 0))
        Mining.LoadAround(Target.CFrame.Position)
        task.wait(Settings.TeleportSettleTime or 0.35)
    end

    local Attempted = 0

    for _, Block in ipairs(Ores) do
        local Live = Mining.RefreshBlock(Block)

        if Live and Live.Part and Live.Part.Parent and Live.CFrame and
            (HumanoidRootPart.Position - Live.CFrame.Position).Magnitude < Range - 1 then

            Attempted += 1

            if not Mining.MineOreReliable(Live) then
                local Key = Mining.GetPositionKey(Block)
                if Key then Mining.FailedPositions[Key] = os.clock() + 10 end
            end
        end
    end

    if Attempted == 0 then
        local Key = Mining.GetPositionKey(Target)
        if Key then Mining.FailedPositions[Key] = os.clock() + 15 end
    end

    task.wait(0.25)
end

-- Birden fazla sutunu AYNI ANDA asagi kazar (hizli kirma + paralel saftlar); nadir yoksa kullanilir
function Mining.DigStep(Known)
    local Range = Settings.MiningRange or 40
    local MaxColumns = math.max(1, Settings.ShaftColumns or 6)

    -- sutunlara ayir (her sutunda en ustteki bilinen blok)
    local Columns = {}

    for _, Block in ipairs(Known) do
        if not Mining.Unbreakable[Block.Dir._id] and not Mining.IsSkipBlock(Block) then
            local Key = ColumnKey(Block)

            if not Mining.DoneColumns[Key] then
                local Col = Columns[Key]

                if not Col then
                    Columns[Key] = {Key = Key, Pattern = IsPatternColumn(Block.Pos), Top = Block}
                elseif Block.CFrame.Position.Y > Col.Top.CFrame.Position.Y then
                    Col.Top = Block
                end
            end
        end
    end

    -- ana sutun: mevcut saft varsa onu surdur, yoksa once grid sutunlari, sonra yakin olan
    local Primary = Mining.CurrentShaft and Columns[Mining.CurrentShaft]

    if not Primary then
        local BestScore

        for _, Col in pairs(Columns) do
            local P = Col.Top.CFrame.Position
            local Flat = Vector3.new(P.X - HumanoidRootPart.Position.X, 0, P.Z - HumanoidRootPart.Position.Z).Magnitude
            local Score = (Col.Pattern and 0 or 100000) + Flat

            if not BestScore or Score < BestScore then
                BestScore = Score
                Primary = Col
            end
        end

        if Primary then
            Mining.CurrentShaft = Primary.Key
            print(("[Dig] yeni saft: sutun %s | grid=%s"):format(Primary.Key, tostring(Primary.Pattern)))
        end
    end

    if not Primary then
        -- kazilacak bir sey kalmadi: yeni blok gelmesini / mine reset'ini bekle
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        Mining.EnsureSupport(HumanoidRootPart.Position)
        task.wait(1)
        return
    end

    -- ayni anda kazilacak diger sutunlar: ana sutunun tepesine yakin, ayni turden (grid / grid disi)
    local ActiveKeys = {[Primary.Key] = Primary}
    local ActiveCount = 1
    local PrimaryTop = Primary.Top.CFrame.Position
    local Candidates = {}

    for _, Col in pairs(Columns) do
        if Col ~= Primary and Col.Pattern == Primary.Pattern then
            local Distance = (Col.Top.CFrame.Position - PrimaryTop).Magnitude

            if Distance < Range - 10 then
                table.insert(Candidates, {Col = Col, Distance = Distance})
            end
        end
    end

    table.sort(Candidates, function(a, b)
        return a.Distance < b.Distance
    end)

    for Index = 1, math.min(#Candidates, MaxColumns - 1) do
        ActiveKeys[Candidates[Index].Col.Key] = Candidates[Index].Col
        ActiveCount += 1
    end

    Mining.Status = ("Saft kaziyor (%d sutun)"):format(ActiveCount)
    Mining.ColumnIdle = Mining.ColumnIdle or {}

    local Rounds = Settings.DigBatch or 12
    local TotalMined = 0

    for Round = 1, Rounds do
        -- her aktif sutunda en ustteki bilinen blok (her turda guncel)
        local Tops = {}
        local KnownNow = Mining.GetKnownBlocks()

        for _, Block in ipairs(KnownNow) do
            if not Mining.Unbreakable[Block.Dir._id] and not Mining.IsSkipBlock(Block) then
                local Key = ColumnKey(Block)

                if ActiveKeys[Key] then
                    local Current = Tops[Key]

                    if not Current or Block.CFrame.Position.Y > Current.CFrame.Position.Y then
                        Tops[Key] = Block
                    end
                end
            end
        end

        local List = {}

        for Key in pairs(ActiveKeys) do
            local Top = Tops[Key]

            if Top then
                Mining.ColumnIdle[Key] = 0
                table.insert(List, Top)
            else
                Mining.ColumnIdle[Key] = (Mining.ColumnIdle[Key] or 0) + 1

                -- sutunda bir sure yeni blok gelmediyse (dip / kirilamayan blok) bitti say
                if Mining.ColumnIdle[Key] >= 6 then
                    Mining.DoneColumns[Key] = true
                    ActiveKeys[Key] = nil

                    if Mining.CurrentShaft == Key then
                        Mining.CurrentShaft = nil
                    end

                    print(("[Dig] sutun %s bitti"):format(Key))
                end
            end
        end

        if next(ActiveKeys) == nil then break end

        -- Az sutun acik (gold kapagi): ana kuyunun cevresindeki ayni katman bloklarini da kir,
        -- boylece yandaki grid sutunlarinin ustu acilir
        local Opening = {}

        if Mining.NeedOpening then
            local Live = 0

            for _ in pairs(ActiveKeys) do Live += 1 end

            if Live >= MaxColumns then
                Mining.NeedOpening = false
            else
                local PrimaryTop = Tops[Primary.Key] or Primary.Top
                local Radius = Settings.ShaftOpenRadius or 3
                local BaseY = PrimaryTop.CFrame.Position.Y

                for _, Block in ipairs(KnownNow) do
                    if not Mining.Unbreakable[Block.Dir._id] and not Mining.IsSkipBlock(Block) and
                        Block.Part and Block.Part.Parent and not ActiveKeys[ColumnKey(Block)] and
                        math.abs(Block.Pos.X - PrimaryTop.Pos.X) <= Radius and
                        math.abs(Block.Pos.Z - PrimaryTop.Pos.Z) <= Radius and
                        math.abs(Block.CFrame.Position.Y - BaseY) <= 3 then
                        table.insert(Opening, Block)
                        table.insert(List, Block)

                        if #Opening >= 12 then break end
                    end
                end

                -- acilacak blok kalmadiysa bu modu birak
                if #Opening == 0 then
                    Mining.NeedOpening = false
                end
            end
        end

        if #List == 0 then
            -- yeni acilan bloklarin sunucudan gelmesini bekle
            task.wait(0.05)
        else
            -- en derin blok menzilden cikmaya basladiysa onun uzerine gec
            table.sort(List, function(a, b)
                return a.CFrame.Position.Y > b.CFrame.Position.Y
            end)

            local Deepest = List[#List]

            if (HumanoidRootPart.Position - Deepest.CFrame.Position).Magnitude > Range - 8 then
                Mining.MoveToMiningPosition(Deepest.CFrame.Position + Vector3.new(0, Settings.HoverHeight or 4, 0))
                task.wait(Settings.TeleportSettleTime or 0.35)
            end

            local InRange = {}

            for _, Block in ipairs(List) do
                if (HumanoidRootPart.Position - Block.CFrame.Position).Magnitude < Range - 1 then
                    table.insert(InRange, Block)
                end
            end

            if #InRange > 0 then
                local Mined = Mining.FastBreakList(InRange, #InRange)
                TotalMined += Mined
            else
                task.wait(0.05)
            end

            -- yan sutunlar acildiysa adimi bitir: sutun listesi bir sonraki adimda yeniden kurulur
            if #Opening > 0 then break end
        end
    end

    Mining.StepCount = (Mining.StepCount or 0) + 1

    if Mining.StepCount % 5 == 1 or Debug.PrintMining then
        print(("[Reveal] SAFT %d sutun | bu adimda kirilan=%d | bilinen=%d"):format(ActiveCount, TotalMined, #Known))
    end

    task.wait()
end

-- Kirilana kadar beklenecek bloklar mi? (ID'sinde ayardaki kelimelerden biri gecer)
function Mining.IsPersistent(Block)
    local List = Settings.PersistentBlocks

    if type(List) ~= "table" then
        List = {"Rainbow"}
    end

    local Id = Block and Block.Dir and Block.Dir._id

    if type(Id) ~= "string" then return false end

    local LowerId = Id:lower()

    for _, Name in ipairs(List) do
        if type(Name) == "string" and Name ~= "" and LowerId:find(Name:lower(), 1, true) then
            return true
        end
    end

    return false
end

-- Blogu KIRILANA KADAR dener; kirilmadikca bir sonraki bloga gecmez
function Mining.BreakPersistent(Block)
    local Network = Mining.GetNetwork()

    if not Network then
        error("[Mining] Could not find the current Network module with a Fire function.")
    end

    local Range = Settings.MiningRange or 40
    local MaxSeconds = Settings.PersistentMaxSeconds or 0
    local MaxExtra = Settings.PersistentMaxExtra or 6
    local Id = Block.Dir and Block.Dir._id
    local Pos = Block.Pos
    local Key = Mining.GetPositionKey(Block)
    local Part = Block.Part
    local Started = os.clock()
    local Extra = 0
    local Cycle = 0

    local function IsGone()
        return not Part or not Part.Parent
    end

    print(("[Persist] %s bulundu, kirilana kadar beklenecek."):format(tostring(Id)))

    while not IsGone() do
        if MaxSeconds > 0 and os.clock() - Started >= MaxSeconds then
            warn(("[Persist] %s %d sn icinde kirilamadi, vazgeciliyor."):format(tostring(Id), MaxSeconds))
            return false
        end

        -- mine resetlendiyse blok zaten gidecek
        if Mining.IsMineResetting and Mining.IsMineResetting() then
            return false
        end

        local Live = Mining.GetLiveBlock(Pos) or Block
        local BlockPosition = (Live.CFrame or Block.CFrame).Position

        -- menzilden ciktiysak blogun yanina git
        if (HumanoidRootPart.Position - BlockPosition).Magnitude >= Range - 1 then
            Mining.MoveToMiningPosition(BlockPosition + Vector3.new(0, Settings.HoverHeight or 4, 0))
            task.wait(Settings.TeleportSettleTime or 0.35)
        end

        local BreakTime = Mining.GetBlockBreakTime(Live)

        Network.Fire("BlockWorlds_Target", Pos, RemoteCounter, false)

        -- hedefleme suresi kadar bekle; blok kendiliginden kirilirsa hemen cik
        local WaitUntil = os.clock() + math.max(BreakTime, 0) + 0.2 + Extra

        repeat
            if IsGone() then break end
            task.wait(0.05)
        until os.clock() >= WaitUntil

        if not IsGone() then
            Network.Fire("BlockWorlds_Break", Pos, RemoteCounter)
            RemoteCounter += 1

            local ConfirmUntil = os.clock() + 0.75

            repeat
                if IsGone() then break end
                task.wait(0.05)
            until os.clock() >= ConfirmUntil
        end

        if not IsGone() then
            Cycle += 1
            Extra = math.min(MaxExtra, Extra + 0.5)

            if Cycle % 5 == 0 then
                print(("[Persist] %s hala kirilmadi (tur %d, ekstra bekleme %.1f sn)"):format(
                    tostring(Id), Cycle, Extra))
            end
        end
    end

    if Key then Mining.MinedPositions[Key] = true end
    if Mining.CountBreak then Mining.CountBreak(Block) end

    print(("[Persist] %s kirildi (%.1f sn)."):format(tostring(Id), os.clock() - Started))

    return true
end

Mining.BreakTimeCache = Mining.BreakTimeCache or {}
Mining.AttemptCount = Mining.AttemptCount or {}

-- Kirma suresi blok turune gore; her blokta yeniden hesaplamak yerine kisa sure onbellekle
function Mining.GetCachedBreakTime(Block)
    local Id = Block.Dir and Block.Dir._id
    local Cached = Id and Mining.BreakTimeCache[Id]

    if Cached and os.clock() - Cached.At < 3 then
        return Cached.Time
    end

    local Time = Mining.GetBlockBreakTime(Block)

    if Id then
        Mining.BreakTimeCache[Id] = {Time = Time, At = os.clock()}
    end

    return Time
end

-- Bloklari pes pese kir (Target -> bekle -> Break), sonda toplu dogrula
function Mining.FastBreakList(List, Limit)
    local Network = Mining.GetNetwork()

    if not Network then
        error("[Mining] Could not find the current Network module with a Fire function.")
    end

    local Margin = Mining.FastMargin or Settings.FastMargin or 0.06
    Mining.FastMargin = Margin

    local Batch = {}
    local PersistentDone = 0

    for _, Block in ipairs(List) do
        if #Batch + PersistentDone >= Limit then break end

        if Block.Part and Block.Part.Parent and Block.Pos then
            if Mining.IsPersistent(Block) then
                -- Rainbow vb.: kirilana kadar bekle, atlama
                if Mining.BreakPersistent(Block) then
                    PersistentDone += 1
                end
            else
                local BreakTime = Mining.GetCachedBreakTime(Block)

                Network.Fire("BlockWorlds_Target", Block.Pos, RemoteCounter, false)
                task.wait(math.max(BreakTime, 0) + Margin)
                Network.Fire("BlockWorlds_Break", Block.Pos, RemoteCounter)
                RemoteCounter += 1

                table.insert(Batch, Block)
            end
        end
    end

    if #Batch == 0 then return PersistentDone, PersistentDone end

    -- sunucudan onay gelmesi icin kisa sure bekle (hepsi kirildiysa hemen cik)
    local WaitUntil = os.clock() + 0.3

    repeat
        local Remaining = 0

        for _, Block in ipairs(Batch) do
            if Block.Part and Block.Part.Parent then
                Remaining += 1
                break
            end
        end

        if Remaining == 0 then break end

        task.wait(0.03)
    until os.clock() >= WaitUntil

    local Mined, Failed = 0, 0

    for _, Block in ipairs(Batch) do
        local Key = Mining.GetPositionKey(Block)

        if Block.Part and Block.Part.Parent then
            Failed += 1

            if Key then
                Mining.AttemptCount[Key] = (Mining.AttemptCount[Key] or 0) + 1

                -- 3 denemede kirilmayan blogu bir sure birak
                if Mining.AttemptCount[Key] >= 3 then
                    Mining.NoteBreak(Block, false)
                    Mining.FailedPositions[Key] = os.clock() + 60
                    Mining.AttemptCount[Key] = nil
                end
            end
        else
            Mining.NoteBreak(Block, true)
            Mined += 1
            if Mining.CountBreak then Mining.CountBreak(Block) end

            if Key then
                Mining.MinedPositions[Key] = true
                Mining.AttemptCount[Key] = nil
            end
        end
    end

    -- bekleme payini otomatik ayarla
    local FailRate = Failed / #Batch

    if FailRate > 0.25 then
        Mining.FastMargin = math.min(0.4, Margin + 0.04)
        print(("[Clear] cok blok kirilamadi (%d/%d), bekleme payi %.2f -> %.2f"):format(
            Failed, #Batch, Margin, Mining.FastMargin))
    elseif Failed == 0 and #Batch >= 10 then
        Mining.FastMargin = math.max(Settings.FastMarginMin or 0.02, Margin - 0.01)
    end

    return Mined + PersistentDone, #Batch + PersistentDone
end

-- Zigzag (boustrophedon) sirala: sutun sutun, tek sutun bir yone, cift sutun ters yone
function Mining.ZigzagSort(List)
    local Region = World:GetRegion()
    local SwapAxes = Settings.ZigzagSwapAxes == true
    local InvertCols = Settings.ZigzagInvertColumns == true
    local InvertRows = Settings.ZigzagInvertRows == true

    local function ColOf(Pos)
        return SwapAxes and Pos.Z or Pos.X
    end

    local function RowOf(Pos)
        return SwapAxes and Pos.X or Pos.Z
    end

    local ColMin = SwapAxes and Region.Min.Z or Region.Min.X
    local ColMax = SwapAxes and Region.Max.Z or Region.Max.X

    local function ColOrdinal(Block)
        if InvertCols then
            return ColMax - ColOf(Block.Pos)
        end
        return ColOf(Block.Pos) - ColMin
    end

    table.sort(List, function(a, b)
        local Ca, Cb = ColOrdinal(a), ColOrdinal(b)

        if Ca ~= Cb then return Ca < Cb end

        local Ra, Rb = RowOf(a.Pos), RowOf(b.Pos)
        local Ascending = (Ca % 2 == 0) ~= InvertRows

        if Ascending then
            return Ra < Rb
        end

        return Ra > Rb
    end)
end

-- Menzildeki en ust katmani zigzag kir, uzerinde durdugumuz blogu katmanin sonunda kir
function Mining.ClearAround(Known, Limit, StandPos)
    local Range = Settings.MiningRange or 40
    local Reachable = {}
    local StandBlock

    local function LayerOf(Block)
        return math.floor(Block.CFrame.Position.Y / 5 + 0.5)
    end

    for _, Block in ipairs(Known) do
        if not Mining.Unbreakable[Block.Dir._id] and
            (HumanoidRootPart.Position - Block.CFrame.Position).Magnitude < Range - 1 then
            if StandPos and Block.Pos == StandPos then
                StandBlock = Block
            else
                table.insert(Reachable, Block)
            end
        end
    end

    -- Rainbow vb. onemli bloklar: hangi katmanda olursa olsun menzildeyse en basa al
    local Priority = {}
    local Rest = {}

    for _, Block in ipairs(Reachable) do
        if Mining.IsPersistent(Block) then
            table.insert(Priority, Block)
        else
            table.insert(Rest, Block)
        end
    end

    Reachable = Rest

    table.sort(Priority, function(a, b)
        return (a.CFrame.Position - HumanoidRootPart.Position).Magnitude <
            (b.CFrame.Position - HumanoidRootPart.Position).Magnitude
    end)

    -- calisilacak katman: menzildeki en ust katman
    local TopLayer = -math.huge

    for _, Block in ipairs(Reachable) do
        TopLayer = math.max(TopLayer, LayerOf(Block))
    end

    if StandBlock then
        TopLayer = math.max(TopLayer, LayerOf(StandBlock))
    end

    local Work = {}

    for _, Block in ipairs(Reachable) do
        if LayerOf(Block) == TopLayer then
            table.insert(Work, Block)
        end
    end

    Mining.ZigzagSort(Work)

    for Index = #Priority, 1, -1 do
        table.insert(Work, 1, Priority[Index])
    end

    -- durdugumuz blok katmanin en sonunda
    if StandBlock and LayerOf(StandBlock) == TopLayer then
        table.insert(Work, StandBlock)
    end

    if Settings.FastClear ~= false then
        return Mining.FastBreakList(Work, Limit)
    end

    local Mined, Attempted = 0, 0

    for _, Block in ipairs(Work) do
        if Attempted >= Limit then break end

        local Live = Mining.RefreshBlock(Block)

        if Live and Live.Part and Live.Part.Parent and Live.CFrame and
            (HumanoidRootPart.Position - Live.CFrame.Position).Magnitude < Range - 1 then

            Attempted += 1

            if Mining.MineOreReliable(Live) then
                Mining.NoteBreak(Block, true)
                Mined += 1
            else
                Mining.NoteBreak(Block, false)
                local Key = Mining.GetPositionKey(Block)
                if Key then Mining.FailedPositions[Key] = os.clock() + 60 end
            end
        end
    end

    return Mined, Attempted
end

-- Karakterin ayaklari blogun ust yuzeyine basacak sekildeki yukseklik farki
function Mining.GetStandOffset(Block)
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Hip = Humanoid and Humanoid.HipHeight or 2

    if Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R6 then
        Hip = 2
    end

    local BlockHeight = 5
    local Part = Block and Block.Part

    if typeof(Part) == "Instance" and Part:IsA("BasePart") then
        BlockHeight = Part.Size.Y
    end

    return BlockHeight / 2 + Hip + HumanoidRootPart.Size.Y / 2
end

-- Ustunde duracagimiz blok: bulundugumuz sutundaki en yuksek bilinen blok,
-- sutunda blok yoksa yatayda en yakin olan
function Mining.FindNearestStandBlock(Known)
    local Pos = HumanoidRootPart.Position
    local InColumn, InColumnY
    local Nearest, NearestFlat

    for _, Block in ipairs(Known) do
        local P = Block.CFrame.Position
        local Flat = math.sqrt((P.X - Pos.X) ^ 2 + (P.Z - Pos.Z) ^ 2)

        if Flat <= 3.6 then
            if not InColumn or P.Y > InColumnY then
                InColumn, InColumnY = Block, P.Y
            end
        end

        if not Nearest or Flat < NearestFlat - 0.5 or
            (math.abs(Flat - NearestFlat) <= 0.5 and P.Y > Nearest.CFrame.Position.Y) then
            Nearest, NearestFlat = Block, Flat
        end
    end

    return InColumn or Nearest
end

-- Ayarlanan duraga karsilik gelen grid hucresi (Pos.X, Pos.Z)
function Mining.GetStandCell()
    local Region = World:GetRegion()
    local Swap = Settings.ZigzagSwapAxes == true
    local InvertCols = Settings.ZigzagInvertColumns == true
    local InvertRows = Settings.ZigzagInvertRows == true

    local ColMin = Swap and Region.Min.Z or Region.Min.X
    local ColMax = Swap and Region.Max.Z or Region.Max.X
    local RowMin = Swap and Region.Min.X or Region.Min.Z
    local RowMax = Swap and Region.Max.X or Region.Max.Z

    local ColCount = ColMax - ColMin + 1
    local RowCount = RowMax - RowMin + 1

    local Col = math.clamp((Settings.StandColumn or math.ceil(ColCount / 2)), 1, ColCount) - 1
    local Row = math.clamp((Settings.StandRow or math.ceil(RowCount / 2)), 1, RowCount) - 1

    local ColValue = InvertCols and (ColMax - Col) or (ColMin + Col)
    local RowValue = InvertRows and (RowMax - Row) or (RowMin + Row)

    if Swap then
        return RowValue, ColValue -- X = satir, Z = sutun
    end

    return ColValue, RowValue
end

-- Duracagimiz blok: ayarlanan hucredeki (sutundaki) en yuksek bilinen blok
function Mining.FindStandBlock(Known)
    if Settings.StandColumn == nil and Settings.StandRow == nil and Settings.StandAtCenter == false then
        return Mining.FindNearestStandBlock(Known)
    end

    local Ok, Cx, Cz = pcall(Mining.GetStandCell)

    if not Ok or Cx == nil then
        return Mining.FindNearestStandBlock(Known)
    end

    local CellText = tostring(Cx) .. "," .. tostring(Cz)

    if Mining.LastStandCell ~= CellText then
        Mining.LastStandCell = CellText
        print("[Clear] durak hucresi (grid X,Z): " .. CellText)
    end

    local Best, BestY

    for _, Block in ipairs(Known) do
        if Block.Pos.X == Cx and Block.Pos.Z == Cz then
            local Y = Block.CFrame.Position.Y

            if not Best or Y > BestY then
                Best, BestY = Block, Y
            end
        end
    end

    if Best then return Best end

    -- hucrede bilinen blok yok: hucreye yatayda en yakin blok
    local Reference = Known[1]
    local TargetOk, Target = pcall(Mining.GridToWorld, Cx, Reference.Pos.Y, Cz)

    if TargetOk and typeof(Target) == "Vector3" then
        local Nearest, NearestFlat

        for _, Block in ipairs(Known) do
            local P = Block.CFrame.Position
            local Flat = math.sqrt((P.X - Target.X) ^ 2 + (P.Z - Target.Z) ^ 2)

            if not Nearest or Flat < NearestFlat - 0.5 or
                (math.abs(Flat - NearestFlat) <= 0.5 and P.Y > Nearest.CFrame.Position.Y) then
                Nearest, NearestFlat = Block, Flat
            end
        end

        if Nearest then return Nearest end
    end

    return Mining.FindNearestStandBlock(Known)
end

-- MineAllBlocks modu: bir blogun USTUNE bas, menzildeki her seyi ustten alta kir, blok altindan gidince asagi in
function Mining.ClearStep()
    Mining.Status = "Tum bloklari kiriyor"
    local Known = {}

    for _, Block in ipairs(Mining.GetKnownBlocks()) do
        if not Mining.Unbreakable[Block.Dir._id] then
            table.insert(Known, Block)
        end
    end

    if #Known == 0 then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        Mining.EnsureSupport(HumanoidRootPart.Position, 16)
        task.wait(0.5)
        return
    end

    local StandBlock = Mining.FindStandBlock(Known)
    local Desired = StandBlock.CFrame.Position + Vector3.new(0, Mining.GetStandOffset(StandBlock), 0)

    -- sadece gerekirse ışınlan: blogun ustune, ayaklar yuzeye basacak sekilde
    if (HumanoidRootPart.Position - Desired).Magnitude > 2.5 then
        Mining.EnsureSupport(Desired, 16)
        HumanoidRootPart.CFrame = CFrame.new(Desired)
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        HumanoidRootPart.Anchored = false
        task.wait(Settings.TeleportSettleTime or 0.35)
    end

    -- platform artik ayagin hemen altinda degil, sadece dusersek yakalayan bir ag (16 stud altta)
    Mining.EnsureSupport(HumanoidRootPart.Position, 16)

    local Mined, Attempted = Mining.ClearAround(Known, Settings.ClearBatch or 40, StandBlock.Pos)

    Mining.StepCount = (Mining.StepCount or 0) + 1

    if Mining.StepCount % 5 == 1 or Debug.PrintMining then
        print(("[Clear] Y=%.0f | bilinen=%d | kirilan=%d/%d | pay=%.2f"):format(
            HumanoidRootPart.Position.Y, #Known, Mined, Attempted, Mining.FastMargin or 0))
    end

    -- hicbir sey kirilamadiysa bu blogu gecici olarak atla (takilmayi onler)
    if Attempted == 0 then
        local Key = Mining.GetPositionKey(StandBlock)
        if Key then Mining.FailedPositions[Key] = os.clock() + 15 end
    end

    task.wait()
end

-- Kazilmayacak (dumduz gecilecek) blok mu? (ID'sinde ayardaki kelimelerden biri gecer)
function Mining.IsSkipBlock(Block)
    local List = Settings.SkipBlocks

    if type(List) ~= "table" then
        List = {"Gold"}
    end

    local Id = Block and Block.Dir and Block.Dir._id

    if type(Id) ~= "string" then return false end

    local LowerId = Id:lower()

    for _, Name in ipairs(List) do
        if type(Name) == "string" and Name ~= "" and LowerId:find(Name:lower(), 1, true) then
            return true
        end
    end

    return false
end

-- Gold (Meteorite) katmani: sadece tek bir sutunda blogu kirip dumduz asagi in
function Mining.DigStraightDown(Known)
    local Range = Settings.MiningRange or 40
    local Mined = 0

    Mining.Status = "Meteorite katmani: duz asagi"

    local function FreshKnown()
        local List = {}

        for _, Block in ipairs(Mining.GetKnownBlocks()) do
            if not Mining.Unbreakable[Block.Dir._id] then
                table.insert(List, Block)
            end
        end

        return List
    end

    for Iteration = 1, 40 do
        local Stand = Mining.FindStandBlock(Known)

        if not Stand or not Mining.IsSkipBlock(Stand) then break end

        -- menzil disindaysak blogun ustune gec
        if (HumanoidRootPart.Position - Stand.CFrame.Position).Magnitude > Range - 8 then
            local Desired = Stand.CFrame.Position + Vector3.new(0, Mining.GetStandOffset(Stand), 0)

            Mining.EnsureSupport(Desired, 16)
            HumanoidRootPart.CFrame = CFrame.new(Desired)
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            HumanoidRootPart.Anchored = false
            task.wait(Settings.TeleportSettleTime or 0.35)
        end

        Mining.EnsureSupport(HumanoidRootPart.Position, 16)

        local StandPos = Stand.Pos

        -- once hizli kir, kirilmadiysa kirilana kadar bekle (asagi inmenin tek yolu bu blok)
        Mining.FastBreakList({Stand}, 1)

        if Stand.Part and Stand.Part.Parent then
            Mining.BreakPersistent(Stand)
        end

        Mined += 1

        -- sutunda yeni blok acilana kadar kisa bekle
        local Deadline = os.clock() + 0.8
        local Advanced = false

        repeat
            task.wait()

            Known = FreshKnown()

            local Next = Mining.FindStandBlock(Known)

            if Next and Next.Pos ~= StandPos then
                Advanced = true
                break
            end
        until os.clock() >= Deadline

        if not Advanced then break end
    end

    if Mined > 0 then
        Mining.NeedOpening = true
        print(("[Dig] Meteorite katmani: %d blok duz kazildi."):format(Mined))
    end

    return Mined
end

function Mining.RevealStep()
    Mining.Status = "Nadir / saft modu"
    local Known = Mining.GetKnownBlocks()

    if #Known == 0 then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        Mining.EnsureSupport(HumanoidRootPart.Position)
        task.wait(0.5)
        return
    end

    local Ores = {}

    for _, Block in ipairs(Known) do
        if Settings.BlockPriority[Block.Dir._id] then
            table.insert(Ores, Block)
        end
    end

    if #Ores > 0 then
        return Mining.MineKnownOres(Ores, #Known)
    end

    -- kazilabilecek (gold olmayan) bilinen blok var mi?
    local Diggable = {}

    for _, Block in ipairs(Known) do
        if not Mining.IsSkipBlock(Block) then
            table.insert(Diggable, Block)
        end
    end

    if #Diggable == 0 then
        -- her sey Gold (Meteorite): tek sutunda dumduz asagi in, magmaya ulas
        Mining.DigStraightDown(Known)
        task.wait()
        return
    end

    return Mining.DigStep(Diggable)
end

function Mining.GetLiveBlock(Pos)
    local Ok, B = pcall(function()
        return World:GetBlock(Pos)
    end)

    if Ok and B and B.Dir then
        return B
    end
end

-- Part yuklu olmasa bile, sadece blok verisi + pozisyonla kirar.
function Mining.MineOreByPos(Ore)
    local Key = Mining.GetPositionKey(Ore)
    local Network = Mining.GetNetwork()

    if not Network then
        error("[Mining] Could not find the current Network module with a Fire function.")
    end

    local OreId = Ore.Dir and Ore.Dir._id

    local function IsGone()
        local Cur = Mining.GetLiveBlock(Ore.Pos)
        if not Cur or Cur.Dir._id ~= OreId then return true end
        if Cur.Part and not Cur.Part.Parent then return true end
        return false
    end

    for Attempt = 1, 3 do
        local Live = Mining.GetLiveBlock(Ore.Pos)

        if not Live then
            if Attempt == 1 then
                -- veri hic okunamadi: kirilmis sayma, basarisiz say
                return false
            end
            if Key then Mining.MinedPositions[Key] = true end
            return true
        end

        if Live.Dir._id ~= OreId or (Live.Part and not Live.Part.Parent) then
            if Key then Mining.MinedPositions[Key] = true end
            return true
        end

        local Position = (Live.CFrame or Ore.CFrame).Position

        if (HumanoidRootPart.Position - Position).Magnitude >= 41 then
            return false
        end

        local BreakTime = Mining.GetBlockBreakTime(Live)

        Network.Fire("BlockWorlds_Target", Live.Pos, RemoteCounter, false)
        task.wait(math.max(BreakTime, 0) + 0.2)
        Network.Fire("BlockWorlds_Break", Live.Pos, RemoteCounter)
        RemoteCounter += 1

        local ConfirmUntil = os.clock() + 0.75

        repeat
            if IsGone() then
                if Key then Mining.MinedPositions[Key] = true end
                return true
            end
            task.wait(0.05)
        until os.clock() >= ConfirmUntil

        Mining.MoveToMiningPosition(HumanoidRootPart.Position)
        task.wait(0.15)
    end

    return false
end

function Mining.SweepStep()
    if not Mining.SweepPlan then
        Mining.SweepPlan = Mining.BuildSweepPlan()
        Mining.SweepIndex = 1
        Mining.StandTries = 0

        if not Mining.SweepPlan then
            warn("[Mining] Sweep plani olusturulamadi (grid -> world donusumu yok).")
            task.wait(1)
            return
        end

        print("[Mining] Sweep plani: " .. #Mining.SweepPlan .. " durak")
    end

    local Stand = Mining.SweepPlan[Mining.SweepIndex]

    if not Stand then
        -- tur bitti, mine reset olana kadar bekle
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        Mining.EnsureSupport(HumanoidRootPart.Position)
        task.wait(1)
        return
    end

    Mining.MoveToMiningPosition(Stand)
    Mining.LoadAround(Stand)
    -- server karakterin yeni pozisyonunu gorsun (menzil kontrolu icin)
    task.wait(Settings.TeleportSettleTime or 0.35)

    if not Mining.DiagPrinted then
        Mining.DiagPrinted = true
        local Reg = World:GetRegion()
        local Loaded = 0
        for _ in pairs(World.Blocks) do Loaded += 1 end
        print(("[Sweep] Region grid Min=%s Max=%s | ilk durak=%s | HRP=%s | yuklu blok=%d"):format(
            tostring(Reg.Min), tostring(Reg.Max), tostring(Stand), tostring(HumanoidRootPart.Position), Loaded))
    end

    -- bloklar yuklenirken sayi sabitlenene kadar bekle
    local Last, StableSince = -1, os.clock()
    local Deadline = os.clock() + (Settings.StreamTimeout or 4)
    local Ores

    repeat
        Ores = Mining.CollectOresAround(Stand)
        if #Ores ~= Last then Last = #Ores; StableSince = os.clock() end
        task.wait(0.15)
    until os.clock() - StableSince >= 0.5 or os.clock() >= Deadline

    if #Ores > 0 or Debug.PrintMining then
        print(("[Sweep] %d/%d  hedef: %d"):format(Mining.SweepIndex, #Mining.SweepPlan, #Ores))
    end

    local AnyFailed = false

    for _, Ore in ipairs(Ores) do
        local Ok
        if Settings.MineWithoutPart ~= false then
            Ok = Mining.MineOreByPos(Ore)
        else
            local Live = Mining.RefreshBlock(Ore)
            Ok = true
            if Live and Live.Part and Live.Part.Parent then
                Ok = Mining.MineOreReliable(Live)
            end
        end

        if not Ok then
            AnyFailed = true
            local Key = Mining.GetPositionKey(Ore)
            if Key then Mining.FailedPositions[Key] = os.clock() + 5 end
        end
    end

    Mining.StandTries = (Mining.StandTries or 0) + 1

    if AnyFailed and Mining.StandTries < 2 then
        return -- ayni durakta bir kez daha dene
    end

    Mining.StandTries = 0
    Mining.SweepIndex += 1
end

----------------------------------------------------------------

function Mining.GetBestLayerPosition(Blocks, LayerY)
    if #Blocks == 0 then return nil end

    local MinX, MaxX = math.huge, -math.huge
    local MinZ, MaxZ = math.huge, -math.huge

    for _, Block in ipairs(Blocks) do
        local Position = Block.CFrame.Position
        MinX = math.min(MinX, Position.X)
        MaxX = math.max(MaxX, Position.X)
        MinZ = math.min(MinZ, Position.Z)
        MaxZ = math.max(MaxZ, Position.Z)
    end

    local Height = Settings.HoverHeight or 4
    local Range = Settings.MiningRange or 40
    local LayerCenter = Vector3.new((MinX + MaxX) / 2, LayerY + Height, (MinZ + MaxZ) / 2)
    local Candidates = {LayerCenter}

    for _, Block in ipairs(Blocks) do
        local Position = Block.CFrame.Position
        table.insert(Candidates, Vector3.new(Position.X, LayerY + Height, Position.Z))
    end

    local BestPosition = LayerCenter
    local BestCount = -1
    local BestCenterDistance = math.huge

    for _, Candidate in ipairs(Candidates) do
        local Reachable = 0

        for _, Block in ipairs(Blocks) do
            if (Candidate - Block.CFrame.Position).Magnitude <= Range then
                Reachable += 1
            end
        end

        local CenterDistance = (Candidate - LayerCenter).Magnitude

        if Reachable > BestCount or (Reachable == BestCount and CenterDistance < BestCenterDistance) then
            BestPosition = Candidate
            BestCount = Reachable
            BestCenterDistance = CenterDistance
        end
    end

    return BestPosition
end

function Mining.GetStableLayerPosition(Blocks, StandY, LayerKey)
    local Range = Settings.MiningRange or 40

    LayerKey = LayerKey or StandY

    local SameLayer = Mining.ActiveLayerY and math.abs(Mining.ActiveLayerY - LayerKey) < 0.25

    if SameLayer and Mining.ActiveStandPosition then
        for _, Block in ipairs(Blocks) do
            if Block and Block.Part and Block.Part.Parent and
                (Mining.ActiveStandPosition - Block.CFrame.Position).Magnitude <= Range then
                -- Keep the exact same position while it can still reach a block.
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                Mining.EnsureSupport(HumanoidRootPart.Position)
                HumanoidRootPart.Anchored = false
                return Mining.ActiveStandPosition, false
            end
        end
    end

    local NewPosition = Mining.GetBestLayerPosition(Blocks, StandY)

    Mining.ActiveLayerY = LayerKey
    Mining.ActiveStandPosition = NewPosition

    if NewPosition and (HumanoidRootPart.Position - NewPosition).Magnitude > 1 then
        Mining.MoveToMiningPosition(NewPosition)
        return NewPosition, true
    end

    Mining.EnsureSupport(HumanoidRootPart.Position)
    HumanoidRootPart.Anchored = false

    return NewPosition, false
end

function Mining.MineBlock(Block, Teleport)
    if not Block or not Block.Part or not Block.Part.Parent then return end

    local BreakTime;
    local Distance = (HumanoidRootPart.Position - Block.CFrame.Position).Magnitude

    if Distance >= 41 then
        if Teleport then
            Mining.MoveToBlock(Block)
            BreakTime = Mining.GetBlockBreakTime(Block)
            task.wait(BreakTime >= 1 and 0.2 or 0.15)
        else
            return
        end
    end

    if not BreakTime then
        BreakTime = Mining.GetBlockBreakTime(Block)
    end

    if Debug.PrintMining then
        print("Mining: "..Block.Dir._id)
        print("Breaking: "..tostring(Block.Pos))
    end

    local Network = Mining.GetNetwork()

    if not Network then
        error("[Mining] Could not find the current Network module with a Fire function.")
    end

    Network.Fire("BlockWorlds_Target", Block.Pos, RemoteCounter, false)
    task.wait(BreakTime)
    Network.Fire("BlockWorlds_Break", Block.Pos, RemoteCounter)

    local PositionKey = Mining.GetPositionKey(Block)

    if PositionKey then
        Mining.MinedPositions[PositionKey] = true
    end

    RemoteCounter += 1
end

function Mining.GetGateQuest()
    local Instance = Library.InstancingCmds.Get()
    local ActiveQuest = Instance:GetSavedValue("QuestActive")

    if not ActiveQuest then return end

    local ToDo = {}

    if ActiveQuest.Amount > ActiveQuest.Progress then
        ToDo[ActiveQuest.OreID or "Blocks"] = (ActiveQuest.Amount - ActiveQuest.Progress)
    else
        return true
    end

    return ToDo
end

function Mining.GetPickaxeQuests(Type)
    local OGPath = Library.Save.Get().NPCQuests
    local NewPath;
    local QuestName;
    local BestPickaxeQuest = 0

    for Quest, Data in next, OGPath do
        if Quest:find("PickaxeQuest") and not Data.Completed then
            local PickaxeQuestType = tonumber(Quest:match("%d"))
            if PickaxeQuestType >= BestPickaxeQuest then
                BestPickaxeQuest = PickaxeQuestType
                NewPath = OGPath[Quest]
                QuestName = Quest
            end
        end
    end

    if Library.InstanceZoneCmds.GetMaximumOwnedZoneNumber() < BestPickaxeQuest then
        return
    end

    local ToDo = {}
    local Remaining = 0

    if NewPath and NewPath.Quests then
        for Quest, Data in pairs(NewPath.Quests) do
            if Data.Amount > Data.Progress then
                ToDo[Data.OreID or "Blocks"] = (Data.Amount - Data.Progress)
                Remaining = Remaining + 1
            end
        end
    end

    return ToDo, QuestName, Remaining
end


function Mining.LoadLayerDown(Ore)
    print("Loading Layer Downwards.")

    local Region = World:GetRegion()

    -- Block grid Y grows downwards in this mine.
    -- MineAllBlocks starts at Min.Y (top); priority farming starts at Max.Y (bottom).
    local StartY = Settings.MineAllBlocks and Region.Min.Y or Region.Max.Y
    local EndY = Settings.MineAllBlocks and Region.Max.Y or Region.Min.Y
    local StepY = Settings.MineAllBlocks and 2 or -2

    for y = StartY, EndY, StepY do
        local LayerBlocks = {}

        for x = Region.Min.X, Region.Max.X, 3 do
            for z = Region.Min.Z, Region.Max.Z, 3 do
                local Block = World:GetBlock(Vector3int16.new(x, y, z))

                if not Block or not Block.Part or not Block.Part.Parent or not Block.CFrame or not Block.Dir then continue end
                if Ore and Block.Dir._id == Ore then continue end
                if not Settings.MineAllBlocks and not Settings.BlockPriority[Block.Dir._id] then continue end

                local PositionKey = Mining.GetPositionKey(Block)

                if PositionKey and Mining.MinedPositions[PositionKey] then continue end

                table.insert(LayerBlocks, Block)
            end
        end

        if #LayerBlocks > 0 then
            local StandPosition, Moved = Mining.GetStableLayerPosition(
                LayerBlocks,
                LayerBlocks[1].CFrame.Position.Y,
                y
            )

            if Moved then task.wait(0.15) end

            local Count = 0

            for _, Block in ipairs(LayerBlocks) do
                if (StandPosition - Block.CFrame.Position).Magnitude <= (Settings.MiningRange or 40) then
                    Mining.MineBlock(Block, false)
                    Count += 1
                end
            end

            return Count
        end
    end

    return 0
end

Mining.EnterInstance("MiningEvent")
Mining.TeleportToZone()

for i, Ore in ipairs(Settings.BlockPriority) do
    Settings.BlockPriority[Ore] = i
end

local BreakTimes = {}

function Mining.TargetBlock(Args)
    if not Args.Amount then Args.Amount = 999999 end
    if not Args.Type then Args.Type = "N/A" end

    if not Args.OreID and not Args.BlockPriority then
        Mining.TeleportToZone(1)
    elseif World.Id ~= Library.InstanceZoneCmds.GetMaximumOwnedZoneNumber() then
        Mining.TeleportToZone()
    end

    local Blocks = {}

    for _, Block in pairs(World.Blocks) do
        if not Args.OreID or (Args.OreID and Block.Dir and Block.Dir._id and Block.Dir._id == Args.OreID) then
            if not Args.BlockPriority or Args.BlockPriority and Settings.BlockPriority[Block.Dir._id] then
                table.insert(Blocks, Block)
                if Args.Amount and #Blocks >= Args.Amount then break end
            end
        end
    end

    table.sort(Blocks, function(a, b)
        if a.Dir.Tier == b.Dir.Tier then
            local DistanceA = (a.CFrame.Position - HumanoidRootPart.Position).Magnitude
            local DistanceB = (b.CFrame.Position - HumanoidRootPart.Position).Magnitude
            return DistanceA < DistanceB
        else
            return a.Dir.Tier > b.Dir.Tier
        end
    end)

    if #Blocks == 0 then
        task.wait(0.5)
        Mining.FocusBlocks(10)
        return Mining.TargetBlock(Args)
    end

    local Count = 0

    for _, Block in pairs(Blocks) do
        if Count > Args.Amount then break end
        if not Block or not Block.Part or not Block.Part.Parent then continue end

        Count = Count + 1
        Mining.MineBlock(Block, true)
    end
end

function Mining.FocusBlocks(Amount)
    local Counter = 0;

    repeat task.wait()
        for _,Block in next, World.Blocks do
            if not Block or not Block.Part or not Block.Part.Parent then continue end
            Mining.MoveToBlock(Block)
            task.wait(0.1)
            break
        end

        Mining.UpdateBlocks(true)

        for _,v in next, Mining.Blocks do
            local BlockPos = World:WorldToBlockPos(v.Position)
            local Block = World:GetBlock(BlockPos)
            Counter += 1
            Mining.MineBlock(Block)
        end
    until Counter > Amount
end


if Debug.DisableUI then
    local Blocks;

    repeat task.wait()
        Blocks = workspace.__THINGS.BlockWorlds["Blocks_"..World.Id]
    until Blocks

    if Mining.AddedConnection then
        Mining.AddedConnection:Disconnect()
    end

    for _,v in next, Blocks:GetChildren() do
        v.CanCollide = false
        v.CollisionGroup = "BlockDisp"

        local Part = v:FindFirstChildOfClass("Part")
        if Part then
            Part.CanCollide = false
        end

        local ID = v:GetAttribute("id")
        if not Settings.MineAllBlocks and not Settings.BlockPriority[ID] then
            v.Transparency = 0.9
        end
    end

    Mining.AddedConnection = Blocks.ChildAdded:Connect(function(v)
        v.CanCollide = false
        v.CollisionGroup = "BlockDisp"

        local Part = v:FindFirstChildOfClass("Part")
        if Part then
            Part.CanCollide = false
        end

        local ID = v:GetAttribute("id")
        if not Settings.MineAllBlocks and not Settings.BlockPriority[ID] then
            v.Transparency = 0.9
        end
    end)
else
    -- Undo collision changes left behind by an earlier execution of this script.
    HumanoidRootPart.Anchored = false
    Mining.RemoveSupport()

    local BlockWorlds = workspace:FindFirstChild("__THINGS")
    BlockWorlds = BlockWorlds and BlockWorlds:FindFirstChild("BlockWorlds")

    local Blocks = BlockWorlds and BlockWorlds:FindFirstChild("Blocks_" .. tostring(World.Id))

    if Blocks then
        for _, Object in ipairs(Blocks:GetDescendants()) do
            if Object:IsA("BasePart") then
                Object.CanCollide = true
                Object.CollisionGroup = "Default"
            end
        end
    end
end

local TimesExecuted = 0
local LastExecute;

function Mining.OreMining()
    if Settings.MineAllBlocks and Settings.RevealMode ~= false then
        return Mining.ClearStep()
    end

    if not Settings.MineAllBlocks then
        if Settings.RevealMode ~= false then
            return Mining.RevealStep()
        end
        if Settings.SweepBottomToTop ~= false then
            return Mining.SweepStep()
        end
        return Mining.PriorityOreMining()
    end

    local Blocks = {}
    local SeenPositions = {}

    for _, Block in pairs(World.Blocks) do
        local PositionKey = Mining.GetPositionKey(Block)

        if Block and Block.Part and Block.Part.Parent and Block.CFrame and Block.Dir and PositionKey and
            not Mining.MinedPositions[PositionKey] and not SeenPositions[PositionKey] and
            (Settings.MineAllBlocks or Settings.BlockPriority[Block.Dir._id]) then
            SeenPositions[PositionKey] = true
            table.insert(Blocks, Block)
        end
    end

    if Settings.MineAllBlocks and #Blocks > 0 then
        local TopLayerIndex = math.huge

        for _, Block in ipairs(Blocks) do
            TopLayerIndex = math.min(TopLayerIndex, Mining.GetLayerIndex(Block))
        end

        local TopLayer = {}

        for _, Block in ipairs(Blocks) do
            if Mining.GetLayerIndex(Block) == TopLayerIndex then
                table.insert(TopLayer, Block)
            end
        end

        local StandY = 0

        for _, Block in ipairs(TopLayer) do
            StandY += Block.CFrame.Position.Y
        end

        StandY /= #TopLayer

        local StandPosition, Moved = Mining.GetStableLayerPosition(TopLayer, StandY, TopLayerIndex)

        if Moved then task.wait(0.15) end

        table.sort(TopLayer, function(a, b)
            local DistanceA = (a.CFrame.Position - StandPosition).Magnitude
            local DistanceB = (b.CFrame.Position - StandPosition).Magnitude
            return DistanceA < DistanceB
        end)

        -- Only mine reachable blocks from the current position. The next pass
        -- re-centres on any top-layer blocks that are still out of range.
        for _, Block in ipairs(TopLayer) do
            if not Block or not Block.Part or not Block.Part.Parent then continue end
            Mining.MineBlock(Block, false)
        end

        -- Give World:GetBlock enough time to drop the blocks just broken.
        task.wait(0.2)
        return
    end

    table.sort(Blocks, function(a, b)
        local PositionA = a.CFrame.Position
        local PositionB = b.CFrame.Position

        -- Grid Y grows downwards, so the largest index is the deepest layer.
        local LayerA = Mining.GetLayerIndex(a)
        local LayerB = Mining.GetLayerIndex(b)

        if LayerA ~= LayerB then
            return LayerA > LayerB
        end

        local PriorityA = Settings.BlockPriority[a.Dir._id] or math.huge
        local PriorityB = Settings.BlockPriority[b.Dir._id] or math.huge

        if PriorityA == PriorityB then
            local DistanceA = (PositionA - HumanoidRootPart.Position).Magnitude
            local DistanceB = (PositionB - HumanoidRootPart.Position).Magnitude
            return DistanceA < DistanceB
        end

        return PriorityA < PriorityB
    end)

    if Blocks[1] and Blocks[1].CFrame then
        Mining.MoveToBlock(Blocks[1])

        if Mining.GetBlockBreakTime(Blocks[1]) >= 0.5 then
            task.wait(0.1)
        end
    end

    for _, Block in ipairs(Blocks) do
        if not Block or not Block.Part or not Block.Part.Parent then continue end
        Mining.MineBlock(Block)
    end

    if #Blocks == 0 then
        local LoadedCount = Mining.LoadLayerDown()

        if LoadedCount == 0 then
            HumanoidRootPart.Anchored = false
            Mining.RemoveSupport()
            Mining.ActiveLayerY = nil
            Mining.ActiveStandPosition = nil
        end
    end
end

local Upgrades = {}
local RequiredUpgrades = {MiningEventLessPetsRequiredPetsToComboThem2 = false, MiningEventIncreaseTierUpChance2 = false}
local Quartz;

if Settings.CombineOres then
    if Library.Items and Library.Items.Misc and Library.EventUpgrades and Library.EventUpgradeCmds then
        Quartz = Library.Items.Misc("Quartz Gem")

        for ID, Data in next, Library.EventUpgrades do
            if ID:find("Mining") and ID:find("2") then
                Upgrades[ID] = Data
            end
        end
    else
        warn("[Mining] The old combine/upgrade APIs are unavailable; disabling CombineOres.")
        Settings.CombineOres = false
    end
end

function Mining.Upgrade()
    if not Quartz then return end

    for ID, Data in next, Upgrades do
        if RequiredUpgrades[ID] then continue end

        for i = 1,5 do
            local Tier = Library.EventUpgradeCmds.GetTier(ID)

            if not Data.TierCosts[Tier + 1] or not Data.TierCosts[Tier + 1]._data then
                RequiredUpgrades[ID] = true
                continue
            end

            local Cost = Data.TierCosts[Tier + 1]._data._am or 1

            if Quartz:CountExact() >= Cost then
                Library.EventUpgradeCmds.Purchase(ID)
            end
        end
    end
end

function Mining.IsMineResetting()
    local BlockWorlds = workspace:FindFirstChild("__THINGS")
    BlockWorlds = BlockWorlds and BlockWorlds:FindFirstChild("BlockWorlds")

    if not BlockWorlds then return false end

    local Occlusion;

    if World and World.Id ~= nil then
        Occlusion = BlockWorlds:FindFirstChild("Occlusion_" .. tostring(World.Id))
    end

    if not Occlusion then
        for _, Object in ipairs(BlockWorlds:GetChildren()) do
            if Object.Name:match("^Occlusion_") then
                Occlusion = Object
                break
            end
        end
    end

    if not Occlusion then return false end

    local Part = Occlusion:FindFirstChild("Part") or Occlusion:FindFirstChildWhichIsA("BasePart", true)

    return Part and Part.Transparency == 0 or false
end


----------------------------------------------------------------
-- CORE GUI (tam ekran istatistik paneli)
----------------------------------------------------------------
Mining.Stats = Mining.Stats or {Blocks = 0, Ores = {}}
Mining.Status = Mining.Status or "Basliyor"

-- Blok verisinden gorunen ismi ogren (ID eski kalsa da isim guncel olabilir)
function Mining.LearnOreName(Block)
    local Dir = Block and Block.Dir
    local Id = Dir and Dir._id

    if type(Id) ~= "string" or not Settings.BlockPriority[Id] then return end

    Mining.OreNames = Mining.OreNames or {}

    if Mining.OreNames[Id] ~= nil then return end

    local Name

    pcall(function()
        local Value = Dir.DisplayName

        if type(Value) == "function" then
            local Ok, Result = pcall(Value, Dir)
            if not Ok then Ok, Result = pcall(Value) end
            Value = Ok and Result or nil
        end

        if type(Value) ~= "string" then Value = Dir.Name end
        if type(Value) ~= "string" then Value = Dir.name end

        if type(Value) == "string" and Value ~= "" then Name = Value end
    end)

    Mining.OreNames[Id] = (Name and Name ~= Id) and Name or false

    -- yardimci cikti: blok verisindeki alanlar
    local Keys = {}

    pcall(function()
        for Key, Value in pairs(Dir) do
            local Kind = typeof(Value)

            if Kind == "string" or Kind == "number" or Kind == "boolean" then
                table.insert(Keys, tostring(Key) .. "=" .. tostring(Value))
            else
                table.insert(Keys, tostring(Key) .. ":" .. Kind)
            end
        end
    end)

    table.sort(Keys)

    print(("[GUI] blok verisi %s -> isim=%s | alanlar: %s"):format(
        Id, tostring(Mining.OreNames[Id] or "bulunamadi"), table.concat(Keys, ", ", 1, math.min(#Keys, 40))))
end

function Mining.CountBreak(Block)
    local Stats = Mining.Stats
    Stats.Blocks += 1

    if Mining.LearnOreName then Mining.LearnOreName(Block) end

    local Id = Block and Block.Dir and Block.Dir._id

    if Id and Settings.BlockPriority[Id] then
        Stats.Ores[Id] = (Stats.Ores[Id] or 0) + 1
    end
end

local function FormatNumber(Value)
    if type(Value) ~= "number" then return "?" end

    local Suffixes = {"", "K", "M", "B", "T", "Qa"}
    local Index = 1

    while math.abs(Value) >= 1000 and Index < #Suffixes do
        Value /= 1000
        Index += 1
    end

    if Index == 1 then
        return tostring(math.floor(Value + 0.5))
    end

    return string.format("%.2f%s", Value, Suffixes[Index])
end

local function FormatDuration(Seconds)
    Seconds = math.max(0, math.floor(Seconds))

    local Hours = math.floor(Seconds / 3600)
    local Minutes = math.floor((Seconds % 3600) / 60)
    local Secs = Seconds % 60

    if Hours > 0 then
        return string.format("%d sa %d dk %d sn", Hours, Minutes, Secs)
    end

    return string.format("%d dk %d sn", Minutes, Secs)
end

local function FormatCount(Value)
    if type(Value) ~= "number" then return "?" end

    if Value < 1000000 then
        local Text = tostring(math.floor(Value + 0.5))
        local Formatted = Text:reverse():gsub("(%d%d%d)", "%1,"):reverse()
        return (Formatted:gsub("^,", ""))
    end

    return FormatNumber(Value)
end

local DefaultGemNames = {"Moonstone", "Star Ruby", "Helium-3", "Nebulite", "Dark Matter"}

local function GetGemNameFilter()
    local Names = Settings.GUIGemNames

    if Names == nil then
        Names = DefaultGemNames
    end

    return Names
end

-- Gosterilen ismin listedeki sirasi (listede yoksa math.huge)
function Mining.GemRank(DisplayName)
    local Names = GetGemNameFilter()

    if type(Names) ~= "table" then return math.huge end

    local Lower = tostring(DisplayName):lower()

    for Index, Name in ipairs(Names) do
        if type(Name) == "string" and Name ~= "" and Lower:find(Name:lower(), 1, true) then
            return Index
        end
    end

    return math.huge
end

-- Envanter container'i uzerinden esya satirlari ({Id, Amount})
function Mining.GetContainerRows(Class)
    local Cmds = Library.InventoryCmds

    if not Cmds then
        local RequireOk, Module = pcall(function()
            return require(NLibrary.Client.InventoryCmds)
        end)
        if RequireOk then Cmds = Module end
    end

    if not Cmds or type(Cmds.State) ~= "function" then
        return nil, "envanter kaynagi bulunamadi"
    end

    local Ok, Result = pcall(function()
        local Store = Cmds.State().container._store._byType[Class]
        local Out = {}

        if Store and Store._byUID then
            for _, Item in pairs(Store._byUID) do
                local Id = Item.GetId and Item:GetId()

                if type(Id) == "string" then
                    table.insert(Out, {Id = Id, Amount = Item._data and Item._data._am or 1})
                end
            end
        end

        return Out
    end)

    if not Ok then return nil, tostring(Result) end

    return Result
end

-- Oyunun kendi sayaci: Library.Items.<Sinif>(ID):CountExact() (eski scriptte Quartz icin bu kullaniliyordu)
function Mining.GetItemCount(Class, Id)
    Mining.ItemObjects = Mining.ItemObjects or {}

    local Key = Class .. ":" .. Id
    local Item = Mining.ItemObjects[Key]

    if Item == nil then
        Item = false

        pcall(function()
            local Items = Library.Items
            if not Items then return end

            local Constructor = Items[Class] or (Items.Types and Items.Types[Class])
            if not Constructor then return end

            local Ok, Object = pcall(Constructor, Id)
            if Ok and type(Object) == "table" or (Ok and typeof(Object) == "userdata") then
                Item = Object
            end
        end)

        Mining.ItemObjects[Key] = Item
    end

    if Item and Item.CountExact then
        local Ok, Count = pcall(function()
            return Item:CountExact()
        end)

        if Ok and type(Count) == "number" then
            return Count
        end
    end

    return nil
end

-- Canli kayit verisinden esya satirlari ({Id, Amount}); ekteki scriptteki gibi Client.Save kullanir
function Mining.GetSaveRows(Class)
    local Candidates = {}

    if not Mining.SaveModule then
        local RequireOk, Module = pcall(function()
            return require(NLibrary.Client.Save)
        end)
        if RequireOk and Module then Mining.SaveModule = Module end
    end

    if Mining.SaveModule then
        table.insert(Candidates, {Name = "Client.Save", Module = Mining.SaveModule})
    end

    if Library.Save then
        table.insert(Candidates, {Name = "Library.Save", Module = Library.Save})
    end

    for _, Candidate in ipairs(Candidates) do
        local Module = Candidate.Module

        if type(Module) == "table" and type(Module.Get) == "function" then
            local Ok, Save = pcall(Module.Get)

            if Ok and type(Save) == "table" and type(Save.Inventory) == "table" then
                local Bucket = Save.Inventory[Class]

                if type(Bucket) == "table" then
                    local Rows = {}

                    for _, Data in pairs(Bucket) do
                        if type(Data) == "table" and type(Data.id) == "string" then
                            table.insert(Rows, {Id = Data.id, Amount = Data._am or 1})
                        end
                    end

                    return Rows, Candidate.Name
                elseif not Mining.SaveDiagPrinted then
                    Mining.SaveDiagPrinted = true

                    local Keys = {}
                    for Key in pairs(Save.Inventory) do table.insert(Keys, tostring(Key)) end
                    table.sort(Keys)

                    warn(("[GUI] %s: Inventory.%s yok. Mevcut: %s"):format(
                        Candidate.Name, tostring(Class), table.concat(Keys, ", ")))
                end
            end
        end
    end
end

-- Envanterdeki gemleri ID'ye gore topla ({[ID] = adet}); filtre display name'e gore
function Mining.GetInventoryGems()
    local Class = Settings.GUIGemClass or "Misc"
    local Names = GetGemNameFilter()
    local UseNames = type(Names) == "table" and #Names > 0
    local Exact = Settings.GUIGemIDs
    local Match = tostring(Settings.GUIGemMatch or "gem"):lower()

    -- 1) canli kayit verisi (ekteki scriptte diamond'i de buradan okuyor)
    local Rows, Source = Mining.GetSaveRows(Class)

    -- 2) yedek: envanter container'i
    if not Rows then
        local ContainerRows, ContainerError = Mining.GetContainerRows(Class)

        if not ContainerRows then return nil, ContainerError end

        Rows, Source = ContainerRows, "InventoryCmds"
    end

    if Mining.GemSource ~= Source then
        Mining.GemSource = Source
        print("[GUI] envanter kaynagi: " .. tostring(Source))
    end

    local Totals = {}

    for _, Row in ipairs(Rows) do
        local Wanted

        if UseNames then
            Wanted = Mining.GemRank(Mining.GetItemDisplayName(Class, Row.Id)) ~= math.huge
        elseif type(Exact) == "table" and #Exact > 0 then
            Wanted = table.find(Exact, Row.Id) ~= nil
        else
            Wanted = Row.Id:lower():find(Match, 1, true) ~= nil
        end

        if Wanted then
            Totals[Row.Id] = (Totals[Row.Id] or 0) + (Row.Amount or 1)
        end
    end

    return Totals
end

-- Esyanin oyundaki display name'i (ID eski kalsa da isim guncel gelir)
local DirectoryNames = {Misc = "MiscItems", Card = "CardItems", Lootbox = "Lootboxes", Box = "Boxes"}

function Mining.GetItemDisplayName(Class, Id)
    Mining.DirectoryCache = Mining.DirectoryCache or {}

    local Cache = Mining.DirectoryCache

    if Cache[Class] == nil then
        Cache[Class] = false

        pcall(function()
            local Module = NLibrary.Directory:FindFirstChild(DirectoryNames[Class] or (Class .. "s"))
            if Module then
                Cache[Class] = require(Module)
            end
        end)
    end

    local Directory = Cache[Class]
    local Info = Directory and Directory[Id]

    if type(Info) ~= "table" then return Id end

    local Name = Info.DisplayName

    if type(Name) == "function" then
        local Ok, Result = pcall(Name, 1)
        Name = Ok and Result or nil
    end

    if type(Name) ~= "string" then Name = Info.name end
    if type(Name) ~= "string" then Name = Info.Name end
    if type(Name) ~= "string" then return Id end

    return Name
end

function Mining.CreateGui()
    if Settings.ShowGUI == false then return end

    local UserInputService = game:GetService("UserInputService")

    pcall(function()
        if getgenv().MiningGui then getgenv().MiningGui:Destroy() end
    end)

    local Colors = {
        Bg = Color3.fromRGB(12, 12, 18),
        Card = Color3.fromRGB(28, 26, 44),
        Accent = Color3.fromRGB(140, 100, 255),
        Muted = Color3.fromRGB(150, 150, 172),
        Text = Color3.fromRGB(240, 240, 250),
    }

    local ToggleKey = Enum.KeyCode.RightShift

    if type(Settings.GUIToggleKey) == "string" then
        local KeyOk, Key = pcall(function() return Enum.KeyCode[Settings.GUIToggleKey] end)
        if KeyOk and Key then ToggleKey = Key end
    end

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "MiningStats"
    Gui.ResetOnSpawn = false
    Gui.DisplayOrder = 999
    Gui.IgnoreGuiInset = true

    local Parented = pcall(function() Gui.Parent = CoreGui end)

    if not Parented or not Gui.Parent then
        Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    getgenv().MiningGui = Gui

    -- tum ekrani kaplayan katman
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.fromScale(1, 1)
    Overlay.BackgroundColor3 = Colors.Bg
    Overlay.BackgroundTransparency = Settings.GUIBackgroundTransparency or 0
    Overlay.BorderSizePixel = 0
    Overlay.Active = true
    Overlay.Parent = Gui

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.AnchorPoint = Vector2.new(0.5, 0.5)
    Content.Position = UDim2.fromScale(0.5, 0.5)
    Content.AutomaticSize = Enum.AutomaticSize.XY
    Content.Size = UDim2.fromOffset(0, 0)
    Content.BackgroundTransparency = 1
    Content.Parent = Overlay

    -- kucuk ekranlarda otomatik olcekle
    pcall(function()
        local Scale = Instance.new("UIScale")
        Scale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 900, 0.6, 1.6)
        Scale.Parent = Content
    end)

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.Padding = UDim.new(0, 14)
    ContentLayout.Parent = Content

    local Order = 0

    local function AddLabel(Text, TextSize, Font, Color, Height)
        Order += 1

        local Label = Instance.new("TextLabel")
        Label.LayoutOrder = Order
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.fromOffset(640, Height)
        Label.Font = Font
        Label.TextSize = TextSize
        Label.TextColor3 = Color
        Label.Text = Text
        Label.Parent = Content

        return Label
    end

    local function AddCardRow()
        Order += 1

        local Row = Instance.new("Frame")
        Row.LayoutOrder = Order
        Row.AutomaticSize = Enum.AutomaticSize.XY
        Row.Size = UDim2.fromOffset(0, 0)
        Row.BackgroundTransparency = 1
        Row.Parent = Content

        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 12)
        Layout.Parent = Row

        return Row
    end

    local CardOrder = 0

    local function AddCard(Row, LabelText, Width)
        CardOrder += 1

        local Card = Instance.new("Frame")
        Card.LayoutOrder = CardOrder
        Card.Size = UDim2.fromOffset(Width, 92)
        Card.BackgroundColor3 = Colors.Card
        Card.BorderSizePixel = 0
        Card.Parent = Row

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = Card

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Colors.Accent
        Stroke.Transparency = 0.6
        Stroke.Thickness = 1
        Stroke.Parent = Card

        local Value = Instance.new("TextLabel")
        Value.BackgroundTransparency = 1
        Value.Size = UDim2.new(1, 0, 0, 58)
        Value.Font = Enum.Font.GothamBold
        Value.TextSize = 32
        Value.TextScaled = true
        Value.TextColor3 = Colors.Text
        Value.Text = "-"
        Value.Parent = Card

        local ValueLimit = Instance.new("UITextSizeConstraint")
        ValueLimit.MaxTextSize = 32
        ValueLimit.Parent = Value

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.fromOffset(0, 58)
        Label.Size = UDim2.new(1, 0, 0, 26)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 15
        Label.TextColor3 = Colors.Muted
        Label.Text = LabelText
        Label.TextTruncate = Enum.TextTruncate.AtEnd
        Label.Parent = Card

        return Value, Card, Label
    end

    AddLabel("MINING FARM", 30, Enum.Font.GothamBold, Colors.Accent, 40)
    AddLabel("Farm suresi", 16, Enum.Font.Gotham, Colors.Muted, 22)
    local TimeValue = AddLabel("0 dk 0 sn", 64, Enum.Font.GothamBold, Colors.Text, 76)
    local StatusValue = AddLabel("-", 18, Enum.Font.Gotham, Colors.Muted, 26)

    local StatRow = AddCardRow()
    local BlocksValue = AddCard(StatRow, "Kirilan blok", 190)
    local PerMinValue = AddCard(StatRow, "Blok / dk", 190)
    local YValue = AddCard(StatRow, "Konum Y", 190)

    AddLabel("Kirilan nadirler", 16, Enum.Font.Gotham, Colors.Muted, 26)

    local OreRow = AddCardRow()
    local OreValues = {}
    local OreLabels = {}

    for _, Id in ipairs(Settings.BlockPriority) do
        local Value, _, Label = AddCard(OreRow, tostring(Id), 140)
        OreValues[Id] = Value
        OreLabels[Id] = Label
    end

    -- envanterdeki gemler (dinamik: yeni gem turu gelince kart eklenir)
    local GemGrid
    local GemCards = {}

    if Settings.GUIShowGems ~= false then
        AddLabel("Envanterdeki gemler", 16, Enum.Font.Gotham, Colors.Muted, 26)

        Order += 1

        GemGrid = Instance.new("Frame")
        GemGrid.Name = "GemGrid"
        GemGrid.LayoutOrder = Order
        GemGrid.AutomaticSize = Enum.AutomaticSize.Y
        GemGrid.Size = UDim2.fromOffset(640, 0)
        GemGrid.BackgroundTransparency = 1
        GemGrid.Parent = Content

        local GridLayout = Instance.new("UIGridLayout")
        GridLayout.CellSize = UDim2.fromOffset(140, 92)
        GridLayout.CellPadding = UDim2.fromOffset(12, 12)
        GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        GridLayout.Parent = GemGrid
    end

    -- gizle butonu (panel icinde) ve tekrar acma butonu (panel gizliyken)
    local function MakeButton(Text, Width, Height)
        local Button = Instance.new("TextButton")
        Button.AnchorPoint = Vector2.new(1, 0)
        Button.Position = UDim2.new(1, -16, 0, 16)
        Button.Size = UDim2.fromOffset(Width, Height)
        Button.BackgroundColor3 = Colors.Card
        Button.BorderSizePixel = 0
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        Button.TextColor3 = Colors.Text
        Button.Text = Text
        Button.AutoButtonColor = true

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Button

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Colors.Accent
        Stroke.Transparency = 0.4
        Stroke.Parent = Button

        return Button
    end

    local HideButton = MakeButton("Gizle  [" .. ToggleKey.Name .. "]", 190, 38)
    HideButton.Parent = Overlay

    local ShowButton = MakeButton("Paneli ac  [" .. ToggleKey.Name .. "]", 200, 32)
    ShowButton.Visible = false
    ShowButton.Parent = Gui

    local function Toggle()
        Overlay.Visible = not Overlay.Visible
        ShowButton.Visible = not Overlay.Visible
    end

    HideButton.MouseButton1Click:Connect(Toggle)
    ShowButton.MouseButton1Click:Connect(Toggle)

    local KeyConnection = UserInputService.InputBegan:Connect(function(Input, Processed)
        if not Processed and Input.KeyCode == ToggleKey then
            Toggle()
        end
    end)

    Gui.Destroying:Connect(function()
        KeyConnection:Disconnect()
    end)

    -- guncelleme dongusu
    local LastGemScan = 0
    local LastOreScan = 0

    task.spawn(function()
        while Gui.Parent do
            pcall(function()
                local Elapsed = os.time() - StartingTime
                local Stats = Mining.Stats

                TimeValue.Text = FormatDuration(Elapsed)
                StatusValue.Text = tostring(Mining.Status or "-")
                YValue.Text = string.format("%.0f", HumanoidRootPart.Position.Y)
                BlocksValue.Text = FormatNumber(Stats.Blocks)
                PerMinValue.Text = string.format("%.0f", Stats.Blocks / math.max(Elapsed / 60, 1 / 60))

                for Id, Value in pairs(OreValues) do
                    Value.Text = FormatNumber(Stats.Ores[Id] or 0)
                end

                -- kart isimleri: elle verilen > blok verisinden ogrenilen > ID
                local Overrides = Settings.OreDisplayNames

                for Id, Label in pairs(OreLabels) do
                    local Name = (type(Overrides) == "table" and Overrides[Id]) or
                        (Mining.OreNames and Mining.OreNames[Id]) or Id

                    if Label.Text ~= Name then Label.Text = Name end
                end

                -- henuz ismi ogrenilmeyen nadirler icin yuklu bloklarda ara
                if os.clock() - LastOreScan >= 3 then
                    LastOreScan = os.clock()

                    local Missing = {}
                    local AnyMissing = false

                    for Id in pairs(OreLabels) do
                        if not (Mining.OreNames and Mining.OreNames[Id] ~= nil) then
                            Missing[Id] = true
                            AnyMissing = true
                        end
                    end

                    if AnyMissing and World and World.Blocks then
                        for _, Block in pairs(World.Blocks) do
                            local BlockId = Block and Block.Dir and Block.Dir._id

                            if BlockId and Missing[BlockId] then
                                Mining.LearnOreName(Block)
                                Missing[BlockId] = nil

                                if next(Missing) == nil then break end
                            end
                        end
                    end
                end

            end)

            task.wait(0.5)
        end
    end)

    -- envanter gemleri AYRI thread'de: takilirsa veya hata verirse panelin geri kalani donmaz
    if GemGrid then
        local function ApplyTotals(Totals)
            local Added = false

            for Id, Amount in pairs(Totals) do
                local Entry = GemCards[Id]

                if not Entry then
                    local DisplayName = Mining.GetItemDisplayName(Settings.GUIGemClass or "Misc", Id)
                    local Value, Card = AddCard(GemGrid, DisplayName, 140)

                    Entry = {Value = Value, Card = Card, Name = DisplayName, Rank = Mining.GemRank(DisplayName)}
                    GemCards[Id] = Entry
                    Added = true

                    print(("[GUI] envanter gemi: %s -> %s"):format(Id, DisplayName))
                end

                Entry.Value.Text = FormatCount(Amount)
            end

            -- envanterden tamamen cikan gemler 0 gorunsun
            for Id, Entry in pairs(GemCards) do
                if Totals[Id] == nil then
                    Entry.Value.Text = "0"
                end
            end

            -- yeni kart eklendiyse listedeki siraya gore diz
            if Added then
                local Sorted = {}

                for Id, Entry in pairs(GemCards) do
                    table.insert(Sorted, {Id = Id, Name = Entry.Name, Rank = Entry.Rank})
                end

                table.sort(Sorted, function(a, b)
                    if a.Rank ~= b.Rank then return a.Rank < b.Rank end
                    return a.Name:lower() < b.Name:lower()
                end)

                for Index, Item in ipairs(Sorted) do
                    GemCards[Item.Id].Card.LayoutOrder = Index
                end
            end
        end

        task.spawn(function()
            -- bu thread'in yetkisini yukselt (aksi halde bazi cagrilar "lacking capability" hatasi veriyor)
            pcall(function() setthreadidentity(8) end)

            print("[GUI] envanter taramasi basladi.")

            local Announced = false
            local LastDebug = 0
            local Baseline = {}
            local ScanStart = os.clock()

            while Gui.Parent do
                local Ok, Err = xpcall(function()
                    -- 1. asama: kayit verisi (kartlar burada olusur)
                    local Totals, GemError = Mining.GetInventoryGems()

                    if not Totals then
                        if not Mining.GemWarned then
                            Mining.GemWarned = true
                            warn("[GUI] envanter okunamadi: " .. tostring(GemError))
                        end
                        return
                    end

                    for Id, Amount in pairs(Totals) do
                        if Baseline[Id] == nil then Baseline[Id] = Amount end
                    end

                    ApplyTotals(Totals)

                    if not Announced then
                        Announced = true

                        local Count = 0
                        for _ in pairs(Totals) do Count += 1 end

                        print(("[GUI] envanter taramasi tamam (%d gem turu)."):format(Count))
                    end

                    -- 2. asama: oyunun kendi sayaci (takilsa bile 1. asamadaki kartlar gorunur)
                    local ExactTotals = {}
                    local AnyExact = false

                    if Settings.GUIUseCountExact ~= false then
                        for Id in pairs(Totals) do
                            local Exact = Mining.GetItemCount(Settings.GUIGemClass or "Misc", Id)

                            if Exact ~= nil then
                                ExactTotals[Id] = Exact
                                AnyExact = true
                            end
                        end

                        if AnyExact then
                            local Merged = {}

                            for Id, Amount in pairs(Totals) do
                                Merged[Id] = ExactTotals[Id] or Amount
                            end

                            ApplyTotals(Merged)

                            if not Mining.CountExactLogged then
                                Mining.CountExactLogged = true
                                print("[GUI] adetler oyunun sayacindan (CountExact) okunuyor.")
                            end
                        end
                    end

                    -- teshis: uc kaynagin degerleri
                    if Settings.GUIInvDebug ~= false and os.clock() - LastDebug >= 15 then
                        LastDebug = os.clock()

                        local ContainerTotals = {}
                        local ContainerRows = Mining.GetContainerRows(Settings.GUIGemClass or "Misc")

                        if ContainerRows then
                            for _, Row in ipairs(ContainerRows) do
                                ContainerTotals[Row.Id] = (ContainerTotals[Row.Id] or 0) + (Row.Amount or 1)
                            end
                        end

                        local Parts = {}

                        for Id, Amount in pairs(Totals) do
                            local Diff = Amount - (Baseline[Id] or Amount)

                            table.insert(Parts, ("%s: save=%s (%s%s) container=%s sayac=%s"):format(
                                Id, tostring(Amount), Diff >= 0 and "+" or "", tostring(Diff),
                                tostring(ContainerTotals[Id]), tostring(ExactTotals[Id])))
                        end

                        table.sort(Parts)
                        print(("[Envanter t=%ds] "):format(os.clock() - ScanStart) .. table.concat(Parts, " | "))
                    end
                end, function(Message)
                    return debug.traceback(tostring(Message), 2)
                end)

                if not Ok and Err ~= Mining.LastGemError then
                    Mining.LastGemError = Err
                    warn("[GUI] gem guncelleme hatasi: " .. tostring(Err))
                end

                task.wait(2)
            end
        end)
    end
end

local GuiOk, GuiError = pcall(Mining.CreateGui)

if not GuiOk then
    warn("[Mining] GUI olusturulamadi: " .. tostring(GuiError))
end


local LastSessionPrint = 0

while task.wait() do
    local SessionTime = os.time() - StartingTime

    if SessionTime - LastSessionPrint >= 10 then
        print("Session Time: " .. tostring(SessionTime) .. "s")
        LastSessionPrint = SessionTime
    end

    Mining.OreMining()

    if Mining.IsMineResetting() then
        HumanoidRootPart.Anchored = false
        Mining.RemoveSupport()
        Mining.ActiveLayerY = nil
        Mining.ActiveStandPosition = nil
        Mining.MinedPositions = {}
        Mining.FailedPositions = {}

        -- Sweep durumunu sifirla (yeni mine icin plan bastan kurulur)
        Mining.SweepPlan = nil
        Mining.SweepIndex = 1
        Mining.StandTries = 0
        Mining.GridRef = nil
        Mining.DiagPrinted = false
        Mining.StepCount = 0
        Mining.DoneColumns = {}
        Mining.CurrentShaft = nil
        Mining.AttemptCount = {}
        Mining.NeedOpening = false

        print("Mine is RESETTING (can take a bit)! Combining ores if enabled.")

        if Settings.CombineOres then
            Mining.Upgrade()

            if RequiredUpgrades[1] and RequiredUpgrades[2] then
                HumanoidRootPart.CFrame = CFrame.new(20606, 22, -19940)
                task.wait(0.5)

                for _, Recipe in next, Library.PetCraftingMachines.MiningCraftMachine.Recipes do
                    local Item = Recipe.Ingredients[1].Item
                    local ID = Item:GetId()
                    local Amount = Item:CountExact()

                    if Amount >= 10 and Recipe.Result:GetId():find("Gem") then
                        local MaxCraft = math.min(10000, math.round(Amount/10))
                        local Success;

                        repeat task.wait()
                            Success = Library.Network.Invoke("PetCraftingachine_Craft", "MiningCraftMachine", Recipe.RecipeIndex, MaxAmount, {["shiny"] = false, ["pet"] = 0})
                        until Success
                    end
                end
            end
        end

        repeat task.wait(0.5) until not Mining.IsMineResetting()
    end
end
-- ANTI-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
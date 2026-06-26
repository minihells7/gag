repeat wait()
until getgenv().Window and getgenv().Fluent and getgenv().SettingManager and getgenv().IslandCaller

local LP = game.Players.LocalPlayer
local Title = "its" .. (getgenv().Premium and " [Premium]" or "") .. " - Beta"
local SubTitle = ""
local Fluent = getgenv().Fluent
local UiSetting = Fluent.Options
local IslandCaller = getgenv().IslandCaller
local SettingManager = getgenv().SettingManager

if not getgenv().Window then
    getgenv().Window = Fluent:CreateWindow({
        Title = Title,
        SubTitle = SubTitle,
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 380),
        Acrylic = false,
        Theme = "Dracula",
        MinimizeKey = Enum.KeyCode.LeftControl
    })
end
local Window = getgenv().Window

local UiOrders = {
    "Shop", "Status Server", "LocalPlayer", "Main", "Setting Farm",
    "Stack Farm", "Farming Other", "Raid", "Upgrade Race", "Volcano Event", "Sea Event"
}

local TabCollections = {}
ElementsCollection = {}
for _, Name in pairs(UiOrders) do
    ElementsCollection[Name] = {}
end

local raceStatsActions = getgenv().raceStatsActions or {
    ["Cyborg"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CyborgTrainer", "Buy")
    end,
    ["Ghoul"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ectoplasm", "BuyCheck", 4)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ectoplasm", "Change", 4)
    end,
    ["Stats Refund"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
    end,
    ["Reroll Race"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
    end
}

local Raidslist = getgenv().Raidslist or {}
local BossSpawn = getgenv().BossSpawn or {}
local CodesHttp = getgenv().CodesHttp or {}
local StopTween = getgenv().StopTween or function() end
local TeleportWorld = getgenv().TeleportWorld or function() end
local Tweento = getgenv().Tweento or function() end
local calcpos = getgenv().calcpos or function() return 0 end
local highest_point = getgenv().highest_point or function() return CFrame.new() end
local LoadBoss = getgenv().LoadBoss or function() end
local getfruitbelow1m = getgenv().getfruitbelow1m or function() end
local AutoActiveColorRip_Indra = getgenv().AutoActiveColorRip_Indra or function() end
local Notify = getgenv().Notify or function() end
local rep = game:GetService("ReplicatedStorage")

local UiIntilize = {
    ["Shop"] = {
        {Mode = "Label", Title = "Buy Melee"},
        {
            Mode = "Button",
            Title = "Teleport Old World",
            Callback = function() TeleportWorld(1) end
        },
        {
            Mode = "Button",
            Title = "Teleport New World",
            Callback = function() TeleportWorld(2) end
        },
        {
            Mode = "Button",
            Title = "Teleport Third World",
            Callback = function() TeleportWorld(3) end
        },
        {
            Mode = "Dropdown",
            Title = "Select Melee To Buy",
            Table = {"Black Leg","Electro","Fishman Karate","Superhuman","Dragon Claw","Death Step","Sharkman Karate","Electric Claw","Dragon Talon","Godhuman","Sanguine Art"},
            Default = "",
            Multi = false,
            OnChange = function(v) getgenv().SelectMelee = v end
        },
        {
            Mode = "Toggle",
            Title = "Buy Melee [Selected]",
            Args = {"BuyMeleeSelect"},
            OnChange = function(state)
                getgenv().BuyMeleeSelect = state
                if state then getgenv().GetMelee(getgenv().SelectMelee) else StopTween() end
            end
        },
        {Mode = "Label", Title = "Race / Stats"},
        {
            Mode = "Dropdown",
            Title = "Select Race / Stats",
            Table = {"Cyborg","Ghoul","Stats Refund","Reroll Race"},
            Default = "",
            Multi = false,
            OnChange = function(v) getgenv().RSSelect = v end
        },
        {
            Mode = "Button",
            Title = "Buy Race / Stats",
            Callback = function()
                local sel = getgenv().RSSelect
                if sel and raceStatsActions[sel] then raceStatsActions[sel]() end
            end
        },
    },
    ["Status Server"] = {
        {Mode = "Label", Title = "Server Status"},
        {Mode = "Label", Title = "Timer:"},
        {Mode = "Label", Title = "Mirage Island:"},
        {Mode = "Label", Title = "Prehistoric Island:"},
        {Mode = "Label", Title = "Kitsune Island:"},
        {Mode = "Label", Title = "Elite Hunter:"},
        {Mode = "Label", Title = "Frozen Dimension:"},
        {Mode = "Label", Title = "Cake Prince Mobs:"},
        {Mode = "Label", Title = "Ancient One Status:"},
        {Mode = "Label", Title = "Server Tools"},
        {
            Mode = "TextBox",
            Title = "Input JobId Here",
            Callback = function(v) getgenv().JIData = v end
        },
        {
            Mode = "Button",
            Title = "Join Server",
            Callback = function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getgenv().JIData, LP)
            end
        },
        {
            Mode = "Button",
            Title = "Join Server [Premium]",
            Callback = function()
                local decoded = tostring(getgenv().decode_job_id and getgenv().decode_job_id(getgenv().JIData) or "")
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, decoded, LP)
            end
        },
        {
            Mode = "Button",
            Title = "Copy Job ID",
            Callback = function()
                setclipboard(game.JobId)
                Notify("Copied Jobid!", 2)
            end
        },
        {
            Mode = "Button",
            Title = "Rejoin Server",
            Callback = function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
            end
        },
        {
            Mode = "Button",
            Title = "Hop Server Less People",
            Callback = function()
                loadstring(game:HttpGet("https://github.com/fI0ntium/tatcadeucomeo/blob/main/HopLessPeople.lua?raw=true"))()
            end
        },
    },
    ["LocalPlayer"] = {
        {
            Mode = "Button",
            Title = "Redeem Code",
            Callback = function()
                for _, v in pairs(CodesHttp) do
                    if #v > 0 then rep.Remotes.Redeem:InvokeServer(v) end
                end
            end
        },
        {
            Mode = "Button",
            Title = "Stop Tween",
            Callback = function() StopTween() end
        },
        {
            Mode = "Button",
            Title = "Open Fruit Shop",
            Callback = function() require(rep.Controllers.UI.FruitShop):Open() end
        },
        {
            Mode = "Button",
            Title = "Open Mirage Fruit Shop",
            Callback = function() require(rep.Controllers.UI.FruitShop):Open("AdvancedFruitDealer") end
        },
        {
            Mode = "Button",
            Title = "Open Inventory",
            Callback = function() require(rep:WaitForChild("Controllers"):WaitForChild("UI"):WaitForChild("Inventory")):Open() end
        },
        {
            Mode = "Button",
            Title = "No Fog",
            Callback = function()
                local c = game.Lighting
                c.FogEnd = 100000
                for _, v in pairs(c:GetDescendants()) do if v:IsA("Atmosphere") then v:Destroy() end end
            end
        },
        {Mode = "Label", Title = "Player Settings"},
        {
            Mode = "Dropdown",
            Title = "Select Stats",
            Table = {"Melee","Sword","Defense","Demon Fruit"},
            OnChange = function(v) getgenv().StatsS = v end
        },
        {
            Mode = "Toggle",
            Title = "Auto Stats",
            Args = {"AutoStats"},
            OnChange = function(state) getgenv().AutoStats = state end
        },
        {
            Mode = "Toggle",
            Title = "Black Screen",
            Args = {"BlackScreenOn"},
            OnChange = function(state)
                getgenv().BlackScreenOn = state
                LP.PlayerGui.Main.Blackscreen.Size = state and UDim2.new(500,0,500,500) or UDim2.new(1,0,500,500)
            end
        },
        {
            Mode = "Toggle",
            Title = "Remove Notification",
            Args = {"RemoveNoti"},
            OnChange = function(state)
                getgenv().RemoveNoti = state
                LP.PlayerGui.Notifications.Enabled = not state
            end
        },
        {
            Mode = "Toggle",
            Title = "Teleport to Mirage",
            Args = {"TeleportMirage"},
            OnChange = function(state)
                getgenv().TeleportMirage = state
                if state then Tweento(highest_point().CFrame * CFrame.new(0, 211.88, 0)) else StopTween() end
            end
        },
        {
            Mode = "Toggle",
            Title = "Auto Load Script [Hop]",
            Args = {"AutoExecute"},
            OnChange = function(state)
                getgenv().AutoExecute = state
                if state then
                    if queue_on_teleport then
                        local currentkey = getgenv().Key
                        queue_on_teleport('repeat task.wait() until game:IsLoaded() getgenv().Key = "' .. tostring(currentkey) .. '" loadstring(game:HttpGet("https://raw.githubusercontent.com/dragonhubdev/dragonwitheveryone/refs/heads/main/Main-Premium.lua"))()')
                    else
                        Notify("Your Executor doesn't support this one!")
                    end
                end
            end
        },
        {Mode = "Label", Title = "Team"},
        {
            Mode = "Dropdown",
            Title = "Select Team",
            Table = {"Pirates","Marines"},
            Default = 1,
            Multi = false,
            OnChange = function(v) getgenv().SelectTeam = v end
        },
        {
            Mode = "Button",
            Title = "Change Team",
            Callback = function()
                rep.Remotes.CommF_:InvokeServer("SetTeam", getgenv().SelectTeam or "Pirates")
            end
        },
    },
    ["Main"] = {
        {Mode = "Label", Title = "Farm Mode"},
        {
            Mode = "Dropdown",
            Title = "Select Method Farm",
            Table = {"Farm Level","Farm Bones","Farm Katakuri","Farm Tyrant"},
            Default = 1,
            Multi = false,
            OnChange = function(v) getgenv().MethodFarm = v end
        },
        {
            Mode = "Toggle",
            Title = "Start Farm",
            Args = {"StartFarm"},
            OnChange = function(state) getgenv().StartFarm = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Quest (Kata/Bones)",
            Args = {"QuestMode"},
            OnChange = function(state) getgenv().QuestMode = state end
        },
        {
            Mode = "Toggle",
            Title = "Ignore Katakuri Boss",
            Args = {"IgnoreKata"},
            OnChange = function(state) getgenv().IgnoreKata = state end
        },
        {Mode = "Label", Title = "Bosses"},
        {
            Mode = "Dropdown",
            Title = "Select Boss",
            Table = BossSpawn,
            Default = "",
            Multi = false,
            OnChange = function(v) getgenv().BossNameSelected = v end
        },
        {
            Mode = "Button",
            Title = "Refresh Boss List",
            Callback = function() LoadBoss() end
        },
        {
            Mode = "Toggle",
            Title = "Kill Boss",
            Args = {"KillBoss"},
            OnChange = function(state) getgenv().KillBoss = state end
        },
        {Mode = "Label", Title = "Farm Material"},
        {
            Mode = "Dropdown",
            Title = "Select Material",
            Table = {"Magma Ore","Scrap","Leather","Fish Tail","Mini Tusk","Conjured Cocoa","Dragon Scale"},
            OnChange = function(v) getgenv().SelectMaterial = v end
        },
        {
            Mode = "Toggle",
            Title = "Farm Material",
            Args = {"FarmMaterial"},
            OnChange = function(state) getgenv().FarmMaterial = state end
        },
    },
    ["Setting Farm"] = {
        {Mode = "Label", Title = "Weapon"},
        {
            Mode = "Dropdown",
            Title = "Select Weapons",
            Table = {"Melee","Sword","Blox Fruit"},
            Default = 1,
            Multi = false,
            OnChange = function(v) getgenv().SWeapon = v end
        },
        {Mode = "Label", Title = "Auto Haki"},
        {
            Mode = "Toggle",
            Title = "Auto Turn on V4",
            Args = {"TurnV4"},
            OnChange = function(state) getgenv().TurnV4 = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Turn on V3",
            Args = {"TurnV3"},
            OnChange = function(state) getgenv().TurnV3 = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Turn on Observation",
            Args = {"TurnKen"},
            OnChange = function(state) getgenv().TurnKen = state end
        },
        {Mode = "Label", Title = "Safety"},
        {
            Mode = "Toggle",
            Title = "Teleport Y if Low Health",
            Args = {"TeleportYHealth"},
            OnChange = function(state) getgenv().TeleportYHealth = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Dodge Terrorshark Skill",
            Args = {"DodgeTerrorSharkSkill"},
            OnChange = function(state) getgenv().DodgeTerrorSharkSkill = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Dodge Sea Beast Skill",
            Args = {"DodgeSBSkill"},
            OnChange = function(state) getgenv().DodgeSBSkill = state end
        },
        {Mode = "Label", Title = "Select Skill"},
        {
            Mode = "Dropdown",
            Title = "Select Weapon to Spam",
            Table = {"Melee","Sword","Gun","Blox Fruit"},
            Multi = true,
            Default = {"Melee","Sword","Gun"},
            OnChange = function(v)
                getgenv().TableInput2 = getgenv().TableInput2 or {}
                getgenv().SelectToolSpam = {}
                for ToolSp, _ in pairs(v) do
                    getgenv().TableInput2[ToolSp] = not getgenv().TableInput2[ToolSp]
                end
                for FormS, kv in pairs(getgenv().TableInput2) do
                    if kv then table.insert(getgenv().SelectToolSpam, FormS) end
                end
            end
        },
    },
    ["Stack Farm"] = {
        {Mode = "Label", Title = "Elite Hunter"},
        {
            Mode = "Toggle",
            Title = "Auto Elite Hunter",
            Args = {"AutoElite"},
            OnChange = function(state) getgenv().AutoElite = state end
        },
        {
            Mode = "Toggle",
            Title = "Hop Elite Hunter",
            Args = {"HopEliteServer"},
            OnChange = function(state) getgenv().HopEliteServer = state end
        },
        {Mode = "Label", Title = "CDK & Soul Guitar"},
        {
            Mode = "Toggle",
            Title = "Auto CDK [Still Bug!]",
            Args = {"AutoCdk"},
            OnChange = function(state) getgenv().AutoCdk = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Soul Guitar [Beta]",
            Args = {"AutoSg"},
            OnChange = function(state) getgenv().AutoSg = state end
        },
        {Mode = "Label", Title = "Boss Soul Reaper"},
        {
            Mode = "Toggle",
            Title = "Attack Soul Reaper",
            Args = {"AttackSR"},
            OnChange = function(state) getgenv().AttackSR = state end
        },
        {
            Mode = "Toggle",
            Title = "Summon Soul Reaper",
            Args = {"SummonSR"},
            OnChange = function(state) getgenv().SummonSR = state end
        },
        {Mode = "Label", Title = "Boss Rip Indra"},
        {
            Mode = "Toggle",
            Title = "Attack Rip Indra",
            Args = {"AttackRip"},
            OnChange = function(state) getgenv().AttackRip = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Active Pad Color",
            Args = {"ActivePad"},
            OnChange = function(state)
                getgenv().ActivePad = state
                if state then
                    if calcpos(Vector3.new(-5424.24755859375, 313.7568054199219, -2264.501953125)) >= 1000 then
                        Tweento(CFrame.new(-12463.6025390625, 378.3270568847656, -7566.0830078125))
                    else
                        AutoActiveColorRip_Indra()
                    end
                end
            end
        },
        {
            Mode = "Toggle",
            Title = "Summon Rip Indra",
            Args = {"SummonRip"},
            OnChange = function(state)
                getgenv().SummonRip = state
                if state and getgenv().Third_Sea then
                    Tweento(CFrame.new(-5560.78857421875, 314.0802917480469, -2663.306396484375))
                else
                    StopTween()
                end
            end
        },
        {Mode = "Label", Title = "Boss Darkbeard"},
        {
            Mode = "Toggle",
            Title = "Attack Darkbeard",
            Args = {"AttackDarkbeard"},
            OnChange = function(state) getgenv().AttackDarkbeard = state end
        },
        {
            Mode = "Toggle",
            Title = "Summon Darkbeard",
            Args = {"SummonDB"},
            OnChange = function(state)
                getgenv().SummonDB = state
                if state and getgenv().Second_Sea then
                    Tweento(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
                else
                    StopTween()
                end
            end
        },
        {Mode = "Label", Title = "Event Game"},
        {
            Mode = "Toggle",
            Title = "Auto New World",
            Args = {"AutoSea2"},
            OnChange = function(state) getgenv().AutoSea2 = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Third World",
            Args = {"AutoSea3"},
            OnChange = function(state) getgenv().AutoSea3 = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Factory",
            Args = {"AutoFactory"},
            OnChange = function(state) getgenv().AutoFactory = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Pirate Raid",
            Args = {"AutoPirateRaid"},
            OnChange = function(state) getgenv().AutoPirateRaid = state end
        },
    },
    ["Farming Other"] = {
        {
            Mode = "Toggle",
            Title = "Auto Trade Bone",
            Args = {"TradeBone"},
            OnChange = function(state) getgenv().TradeBone = state end
        },
        {
            Mode = "Toggle",
            Title = "Random Devil Fruit",
            Args = {"RandomFruit"},
            OnChange = function(state)
                getgenv().RandomFruit = state
                if state then rep.Remotes.CommF_:InvokeServer("Cousin", "Buy") end
            end
        },
        {
            Mode = "Toggle",
            Title = "Store Devil Fruit",
            Args = {"StoreFruit"},
            OnChange = function(state)
                getgenv().StoreFruit = state
                if state then
                    for _, item in pairs(LP.Backpack:GetChildren()) do
                        if item:IsA("Tool") and string.find(item.Name, "Fruit") then
                            rep.Remotes.CommF_:InvokeServer("StoreFruit", item:GetAttribute("OriginalName"), item)
                        end
                    end
                end
            end
        },
        {Mode = "Label", Title = "Weapon Quests"},
        {
            Mode = "Toggle",
            Title = "Auto Get Saber",
            Args = {"Kaitun"},
            OnChange = function(state) getgenv().Kaitun = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Get Bisento",
            Args = {"AutoBisento"},
            OnChange = function(state) getgenv().AutoBisento = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Dojo Hunter Quest",
            Args = {"DojoHunter"},
            OnChange = function(state) getgenv().DojoHunter = state end
        },
    },
    ["Raid"] = {
        {Mode = "Label", Title = "Raid"},
        {
            Mode = "Dropdown",
            Title = "Select Raid",
            Table = Raidslist,
            Default = 1,
            Multi = false,
            OnChange = function(v) getgenv().selectraid = v end
        },
        {
            Mode = "Toggle",
            Title = "Full Raid",
            Args = {"FullRaidBeta"},
            OnChange = function(state) getgenv().FullRaidBeta = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Awake Fruit",
            Args = {"AwakeFruit"},
            OnChange = function(state) getgenv().AwakeFruit = state end
        },
        {
            Mode = "Button",
            Title = "Get Low Fruit in Inventory",
            Callback = function()
                rep.Remotes.CommF_:InvokeServer("LoadFruit", getfruitbelow1m())
            end
        },
    },
    ["Upgrade Race"] = {
        {Mode = "Label", Title = "Draco Race"},
        {
            Mode = "Toggle",
            Title = "Auto Draco V2",
            Args = {"DracoV2"},
            OnChange = function(state) getgenv().DracoV2 = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Draco V4 Trial",
            Args = {"DracoTrialV4"},
            OnChange = function(state) getgenv().DracoTrialV4 = state end
        },
        {Mode = "Label", Title = "Race Normal"},
        {
            Mode = "Toggle",
            Title = "Auto Upgrade Race V2-V3",
            Description = "Includes Cyborg, Human, Rabbit, Angel",
            Args = {"UpgradeRaceV23"},
            OnChange = function(state) getgenv().UpgradeRaceV23 = state end
        },
        {Mode = "Label", Title = "Race V4"},
        {
            Mode = "Toggle",
            Title = "Auto Train V4",
            Args = {"AutoTrainV4"},
            OnChange = function(state) getgenv().AutoTrainV4 = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Buy Gear",
            Args = {"AutoBuyGear"},
            OnChange = function(state) getgenv().AutoBuyGear = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Trial V4",
            Args = {"AutoTrialV4"},
            OnChange = function(state) getgenv().AutoTrialV4 = state end
        },
        {
            Mode = "Toggle",
            Title = "Kill Player After Trial",
            Args = {"KillTrial"},
            OnChange = function(state) getgenv().KillTrial = state end
        },
    },
    ["Volcano Event"] = {
        {Mode = "Label", Title = "Volcano Event"},
        {
            Mode = "Toggle",
            Title = "Auto Craft Volcanic Magnet",
            Args = {"CraftVM"},
            OnChange = function(state) getgenv().CraftVM = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Find Prehistoric Island",
            Args = {"FindPreIs"},
            OnChange = function(state) getgenv().FindPreIs = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Event Prehistoric Island",
            Args = {"EventPreIs"},
            OnChange = function(state) getgenv().EventPreIs = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Collect Bones",
            Args = {"CollectBones"},
            OnChange = function(state) getgenv().CollectBones = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Collect Eggs",
            Args = {"CollectEggs"},
            OnChange = function(state) getgenv().CollectEggs = state end
        },
    },
    ["Sea Event"] = {
        {
            Mode = "Slider",
            Title = "Ship Speed",
            Args = {"ShipSpeedValue"},
            Default = getgenv().ShipSpeedValue or 300,
            Min = 50,
            Max = 600,
            OnChange = function(v) getgenv().ShipSpeedValue = v end
        },
        {
            Mode = "Dropdown",
            Title = "Select Ship",
            Table = {"PirateGrandBrigade","PirateShip","PirateWarship"},
            Default = 1,
            Multi = false,
            OnChange = function(v) getgenv().SelectedShip = v end
        },
        {
            Mode = "Toggle",
            Title = "Start Sea Event Farm",
            Description = "For Farming Sharks, Piranha, Terror Shark, SeaBeast, Ship",
            Args = {"AutoSeaEvent"},
            OnChange = function(state) getgenv().AutoSeaEvent = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Terror Shark",
            Args = {"AutoTerrorShark"},
            OnChange = function(state) getgenv().AutoTerrorShark = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Ship",
            Args = {"AutoShip"},
            OnChange = function(state) getgenv().AutoShip = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Shark",
            Args = {"AutoShark"},
            OnChange = function(state) getgenv().AutoShark = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Piranha",
            Args = {"AutoPiranha"},
            OnChange = function(state) getgenv().AutoPiranha = state end
        },
        {Mode = "Label", Title = "Kitsune Event"},
        {
            Mode = "Button",
            Title = "Tween to Kitsune Island",
            Callback = function()
                if game.Workspace.Map.KitsuneIsland then
                    Tweento(game.Workspace.Map.KitsuneIsland.ShrineActive.NeonShrinePart.CFrame * CFrame.new(0, 100, 0))
                end
            end
        },
        {
            Mode = "Toggle",
            Title = "Auto Find Kitsune Island",
            Args = {"FindKitsune"},
            OnChange = function(state) getgenv().FindKitsune = state end
        },
        {
            Mode = "Toggle",
            Title = "Auto Collect Azure Ember",
            Args = {"CollectAzure"},
            OnChange = function(state) getgenv().CollectAzure = state end
        },
        {
            Mode = "Slider",
            Title = "Auto Value Azure Ember",
            Args = {"ValueAzureEmber"},
            Default = getgenv().ValueAzureEmber or 15,
            Min = 5,
            Max = 25,
            OnChange = function(v) getgenv().ValueAzureEmber = v end
        },
        {
            Mode = "Toggle",
            Title = "Auto Pray Kitsune Island",
            Args = {"PrayKitsune"},
            OnChange = function(state) getgenv().PrayKitsune = state end
        },
        {Mode = "Label", Title = "Leviathan Event"},
        {Mode = "Label", Title = "Leviathan - Coming Soon"},
    },
}

local BuildUI = function(Tab, i, v, Name)
    if v.Mode == "Toggle" then
        local BuildToggle = {}
        BuildToggle.Title = T(v.Title)
        BuildToggle.Default = (v.Args and getgenv()[v.Args[1]]) or false
        if v.Description then
            BuildToggle.Description = T(v.Description)
        end
        ElementsCollection[Name][v.Title] = Tab:AddToggle(v.Title, BuildToggle)
        ElementsCollection[Name][v.Title]:OnChanged(function()
            local val = UiSetting[v.Title] and UiSetting[v.Title].Value
            if v.OnChange then
                v.OnChange(val)
            elseif v.Args then
                getgenv()[v.Args[1]] = val
            end
        end)
    elseif v.Mode == "Label" then
        local BuildLabel = {}
        BuildLabel.Title = T(v.Title)
        if v.Content then BuildLabel.Content = v.Content end
        ElementsCollection[Name][v.Title] = Tab:AddParagraph(BuildLabel)
    elseif v.Mode == "Button" then
        local BuildButton = {}
        BuildButton.Title = T(v.Title)
        BuildButton.Callback = v.Callback
        if v.Description then
            BuildButton.Description = T(v.Description)
        end
        ElementsCollection[Name][v.Title] = Tab:AddButton(BuildButton)
    elseif v.Mode == "Slider" then
        local BuildSlider = {}
        BuildSlider.Title = T(v.Title)
        if v.Description then BuildSlider.Description = T(v.Description) end
        if v.Default then BuildSlider.Default = v.Default end
        BuildSlider.Min = v.Min
        BuildSlider.Max = v.Max
        BuildSlider.Rounding = 1
        ElementsCollection[Name][v.Title] = Tab:AddSlider(v.Title, BuildSlider)
        ElementsCollection[Name][v.Title]:OnChanged(function(v2)
            v.OnChange(tonumber(v2))
        end)
    elseif v.Mode == "Dropdown" then
        local BuildDropdown = {}
        BuildDropdown.Title = T(v.Title)
        if v.Description then BuildDropdown.Description = T(v.Description) end
        if v.Multi then BuildDropdown.Multi = v.Multi end
        if v.Default then BuildDropdown.Default = v.Default end
        BuildDropdown.Values = v.Table
        ElementsCollection[Name][v.Title] = Tab:AddDropdown(v.Title, BuildDropdown)
        ElementsCollection[Name][v.Title]:OnChanged(v.OnChange)
    elseif v.Mode == "TextBox" then
        local BuildTextBox = {}
        BuildTextBox.Title = T(v.Title)
        BuildTextBox.Callback = v.Callback
        BuildTextBox.Finished = v.Finished
        ElementsCollection[Name][v.Title] = Tab:AddInput(v.Title, BuildTextBox)
    end
end

for _, Name in pairs(UiOrders) do
    TabCollections[Name] = Window:AddTab({ Title = T(Name), Icon = "" })
    local Tab = TabCollections[Name]
    for i, v in pairs(UiIntilize[Name] or {}) do
        if type(v) == "function" then
            for i2, v2 in pairs(v()) do
                BuildUI(Tab, i2, v2, Name)
            end
        else
            BuildUI(Tab, i, v, Name)
        end
        if getgenv().SlowLoadUi then task.wait() end
    end
end

Window:SelectTab(1)
return Title, SubTitle, ElementsCollection

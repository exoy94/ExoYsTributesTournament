--[[ -------------]]
--[[ --- Notes ---]]
--[[ -------------]]

-- A Tournament as a Object, containing 
-- + playerLists
-- + tournament type 
-- + rules etc 

-- Chat Handler to Read and Prepare Messages 

-- Phases: 
-- 1) "Open Tournament and set AutoInvite" (at first all sizes work with this, add LibDataShare later)
-- 2) Players can invite themself / or be added (Do you get @name from people in chat in all cases? ) 
-- 3) Define Rounds to play   <---|
-- 4) Record Outcomes  -----------|
-- 5) Output Rankings 



--TributesTournament = TributesTournament or {}

local Name = "ExoYsTributesTournament"
--local ToTT = TributesTournament
local EM = GetEventManager() 
local WM = GetWindowManager()


local T = {}
local R = {}
local G = {}
local invite = false

local function InitTournament(id) 
    T = {
        id = id,
        status = 'invite',
        player = {}, 
        score = {}, 
        numPlayer = 0, 
        heighestScore = 0, 
        round = {}, 
        gamesPlayed = {}, 
        ranking = {}, 
    }
    invite = true
end 


local function CreateGui()  
    local win = WM:CreateTopLevelWindow( Name.."Window" ) 
    local ctrl = WM:CreateControl( Name.."Control", win, CT_CONTROL )
    local back = WM:CreateControl( Name.."Control", ctrl, CT_BACKDROP )
    local ranking = WM:CreateControl( Name.."Control", ctrl, CT_LABEL )
    local round = WM:CreateControl( Name.."Round", ctrl, CT_LABEL)

    return {back, ranking, round}
end 


local function AdjustGuiSize() 

    local width = G.ranking:GetTextWidth() 
    local height = G.ranking:GetTextHeight() 

    for control, _ in pairs(G) do 
        control:SetDimensions(width, height) 
    end 

end


local function PrintRanking() 
    local output = ""
    for rank, id in ipairs(T.ranking) do 
        output = output..zo_strformat("[<<1>>] <<2>> \n", rank, T.player[id])  
    end 
    G.ranking:SetText(output) 
end 


local function IsOdd(n) 
    return n%2 == 1 
end 


local function GetPlayerId(name) 
    if ZO_IsTableEmpty(T) then return end 
    for k, v in ipairs(T.player) do 
        if v == name then return k 
    end 
end


local function PrintRound() 
    local output = ""
    for k,v in ipairs(R) do 
        output = output..zo_strformat("[<<1>>] <<2>> VS <<3>>\n", k, T.player[v[1]], T.player[v[2]])  
    end 
    G.ranking:SetText(output)     
end


local function FirstRound() 
    local Player = {} 
    local PausePlayer = 0
    local Num = T.numPlayer 
    for i = 1,Num do 
        table.insert( Player, i)
    end 
    if IsOdd(Num) then 
        PausePlayer = math.random(Num)
        table.remove( Player, PausePlayer)
        Num = Num - 1
    end
    for i = 1, Num/2 do 
        table.insert( R, {} )
    end
    for k, v in ipairs(R) do 
        v[1] = math.random( Num )
        table.remove( Player, v[1])
        Num = Num - 1
        v[2] = math.random(Num)
        table.remove( Player, v[2])
        Num = Num - 1
    end 
end


local function NextRound() 
    if ZO_IsTableEmpty(T) then return end


    local Available = {}
    for k,v in ipairs( T.player) do
        Available[k] = true
    end
    -- Swiss Round Determination
    local Player
    local Opponent
    for rank, playerId in ipairs(T.ranking) do
        --TODO handle last match in special way 
        if Available[playerId] then 
            Available[playerId] = false 
            for k,v in ipairs(Available) do 
                if v then 
                    --TODO check if they already played 
                    Opponent = k 
                    break
                end               
            end 
            table.insert(R, {[1] = playerId, [2] = Opponent})
            Available[playerId] = false 
            Available[Opponent] = false 
        end 
    end 

end 


local function StartTournament() 
    if ZO_IsTableEmpty(T) then return end
    invite = false
    PrintRanking() 
    AdjustGuiSize() 
    FirstRound() 
end 


local function CloseRound() 
    if ZO_IsTableEmpty(T) then return end
    --Check if all games were played
    --TODO update Ranking
    --Clear Round-Table
end


local function FinishTournament() 
    if ZO_IsTableEmpty(T) then return end
    --TODO Delete Table 
end 


--[[ -------------------- ]]
--[[ --- Chat Handler --- ]]
--[[ -------------------- ]]

local function AddPlayer( name ) 
    local num = T.numPlayer + 1
    T.player[num] = name
    T.score[num] = 0
    T.gamesPlayed[num] ={}
    T.numPlayer = num
end 

local function OnChatEvent() 
    if not invite then return end 

    local inviteStr = ZO_StringFormat('+ToTT_<<1>>', T.id )

    if message = inviteStr then 
        AddPlayer(playerName) 
    end 
end 

--[[ --------------------- ]]
--[[ --- Chat Commands --- ]]
--[[ --------------------- ]]

SLASH_COMMANDS["/tott_init"] = InitTournament
SLASH_COMMANDS["/tott_start"] = StartTournament
SLASH_COMMANDS["/tott_close"] = CloseRound
SLASH_COMMANDS["/tott_next"] = NextRound
SLASH_COMMANDS["/tott_finish"] = FinishTournament

SLASH_COMMANDS["/tott_manual"] = function(accountName) 
    if not invite then return end 
    AddPlayer(accountName)
end 

--[[ ------------------ ]]
--[[ --- Initialize --- ]]
--[[ ------------------ ]]

local function Initialize() 

    G = CreateGui() 
    
    --TODO Event for Chat Listener for Auto Invite 

end 


local function OnAddonLoaded(_, addonName) 
    if addonName = Name then 
        EM:UnregisterForEvent(Name, EVENT_ADDON_LOADED)
        Initialize()
    end 
end

EM:RegisterForEvent(Name, EVENT_ADDON_LOADED, OnAddonLoaded)
-- Register Event
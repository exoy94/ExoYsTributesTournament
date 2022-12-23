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



TributesTournament = TributesTournament or {}

local ToTT = TributesTournament
local EM = GetEventManager() 
local WM = GetWindowManager()


local T = {}
local R = {}
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


local function IsOdd(n) 
    return n%2 == 1 
end 


local function GetPlayerId(name) 
    if ZO_IsTableEmpty(T) then return end 
    for k, v in ipairs(T.player) do 
        if v == name then return k 
    end 
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
    -- Swiss Round Determination

end 


local function StartTournament() 
    if ZO_IsTableEmpty(T) then return end
    invite = false
    FirstRound() 
end 


local function CloseRound() 
    if ZO_IsTableEmpty(T) then return end
    --Check if all games were played
    --TODO update Ranking
end


local function FinishTournament() 
    if ZO_IsTableEmpty(T) then return end
    --TODO Delete Table 
end 







--[[ --------------------- ]]
--[[ --- Chat Commands --- ]]
--[[ --------------------- ]]

SLASH_COMMANDS["/tott_init"] = InitTournament
SLASH_COMMANDS["/tott_start"] = StartTournament
SLASH_COMMANDS["/tott_next"] = NextRound
SLASH_COMMANDS["/tott_finish"] = FinishTournament


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


--[[ ------------------ ]]
--[[ --- Initialize --- ]]
--[[ ------------------ ]]

local function Initialize() 

    -- Gui window like LGM



end 


local function OnAddonLoaded(_, addonName) 
    if addonName = then 
        Initialize() 
        -- Unregister Event 
    end 
end

-- Register Event
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





--[[ --------------------- ]]
--[[ --- Chat Commands --- ]]
--[[ --------------------- ]]


local function InitTournament(id) 

end 
SLASH_COMMANDS["/tott_init"] = InitTournament


local function StartTournament(id) 

end 
SLASH_COMMANDS["/tott_start"] = StartTournament


local function FinishTournament(id) 

end 
SLASH_COMMANDS["/tott_finish"] = FinishTournament() 



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
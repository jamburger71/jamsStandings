local _remoteHandler = require(script.StandingsLocalRemoteHandler)

local _flagService = require(script.GuiLogic.StandingsFlagService)
local _stateService = require(script.GuiLogic.StandingsStateService)
local _towerService = require(script.GuiLogic.StandingsTowerService)

local _adminService = require(script.AdminLogic.StandingsAdminService)
local _buttonService = require(script.AdminLogic.StandingsButtonService)
local _settingsService = require(script.AdminLogic.StandingsSettingsService)

function Init()

	-- REMOTE
	_remoteHandler:Init()
	
	-- FOR GUI
	_flagService:Init()
	_stateService:Init()
	_towerService:Init()

	-- FOR ADMIN
	_adminService:Init()
	_buttonService:Init()
	_settingsService:Init()

end

Init()
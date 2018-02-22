local utility = require('shared.utility')
local Page = require('settings.pages.page')
local Settings = require('settings.types')
local GOGGalaxy
do
  local _class_0
  local _parent_0 = Page
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.title = 'GOG Galaxy'
      self.settings = {
        Settings.Boolean({
          title = LOCALIZATION:get('setting_gog_galaxy_enabled_title', 'Enabled'),
          tooltip = LOCALIZATION:get('setting_gog_galaxy_enabled_description', 'If enabled, then games installed via the GOG Galaxy client will be included.'),
          toggle = function(self)
            COMPONENTS.SETTINGS:toggleGOGGalaxyEnabled()
            return true
          end,
          getState = function(self)
            return COMPONENTS.SETTINGS:getGOGGalaxyEnabled()
          end
        }),
        Settings.FolderPath({
          title = LOCALIZATION:get('setting_gog_galaxy_client_path_title', 'Client path'),
          tooltip = LOCALIZATION:get('setting_gog_galaxy_client_path_description', 'The folder that contains the GOG Galaxy client executable.'),
          getValue = function(self)
            return COMPONENTS.SETTINGS:getGOGGalaxyClientPath()
          end,
          setValue = function(self, path)
            return COMPONENTS.SETTINGS:setGOGGalaxyClientPath(path)
          end,
          dialogTitle = 'Select the folder containing \'GalaxyClient.exe\''
        }),
        Settings.FolderPath({
          title = LOCALIZATION:get('setting_gog_galaxy_program_data_path_title', 'ProgramData path'),
          tooltip = LOCALIZATION:get('setting_gog_galaxy_program_data_path_description', 'The path where the GOG Galaxy client stores some of its data.'),
          getValue = function(self)
            return COMPONENTS.SETTINGS:getGOGGalaxyProgramDataPath()
          end,
          setValue = function(self, path)
            return COMPONENTS.SETTINGS:setGOGGalaxyProgramDataPath(path)
          end
        }),
        Settings.Boolean({
          title = LOCALIZATION:get('setting_gog_galaxy_indirect_launch_title', 'Indirect launch'),
          tooltip = LOCALIZATION:get('setting_gog_galaxy_indirect_launch_description', 'If enabled, then games will be launched via the GOG Galaxy client.\nLaunching via the client allows the client\'s overlay to be used and for the client to track the amount of time played.'),
          toggle = function(self)
            COMPONENTS.SETTINGS:toggleGOGGalaxyIndirectLaunch()
            return true
          end,
          getState = function(self)
            return COMPONENTS.SETTINGS:getGOGGalaxyIndirectLaunch()
          end
        }),
        Settings.Action({
          title = LOCALIZATION:get('setting_gog_galaxy_starting_bangs_title', 'Starting bangs'),
          tooltip = LOCALIZATION:get('setting_gog_galaxy_starting_bangs_description', 'These Rainmeter bangs are executed just before any GOG Galaxy game launches.'),
          label = LOCALIZATION:get('button_label_edit', 'Edit'),
          perform = function(self)
            local path = 'cache\\bangs.txt'
            local bangs = COMPONENTS.SETTINGS:getGOGGalaxyStartingBangs()
            io.writeFile(path, table.concat(bangs, '\n'))
            return utility.runCommand(('""%s""'):format(io.joinPaths(STATE.PATHS.RESOURCES, path)), '', 'OnEditedGOGGalaxyStartingBangs')
          end
        }),
        Settings.Action({
          title = LOCALIZATION:get('setting_gog_galaxy_stopping_bangs_title', 'Stopping bangs'),
          tooltip = LOCALIZATION:get('setting_gog_galaxy_stopping_bangs_description', 'These Rainmeter bangs are executed just after any GOG Galaxy game terminates.'),
          label = LOCALIZATION:get('button_label_edit', 'Edit'),
          perform = function(self)
            local path = 'cache\\bangs.txt'
            local bangs = COMPONENTS.SETTINGS:getGOGGalaxyStoppingBangs()
            io.writeFile(path, table.concat(bangs, '\n'))
            return utility.runCommand(('""%s""'):format(io.joinPaths(STATE.PATHS.RESOURCES, path)), '', 'OnEditedGOGGalaxyStoppingBangs')
          end
        })
      }
    end,
    __base = _base_0,
    __name = "GOGGalaxy",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GOGGalaxy = _class_0
end
return GOGGalaxy

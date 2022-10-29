local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local AceGUI = LibStub("AceGUI-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

function private:GetBindingSetsOptions()
	local options = {
		newSet = {
			order = 1,
			type = "input",
			name = L["New Binding Set"],
			set = function(_, value)
				private:SaveBindingSet(value)
				private:RefreshOptions()
			end,
			validate = function(_, value)
				return not private:BindingSetExists(value) or L["Duplicate binding set name."]
			end,
		},
	}

	for setName, bindingSet in pairs(private.db.global.bindingSets) do
		options[setName] = {
			type = "group",
			name = setName,
			args = {
				setName = {
					order = 1,
					type = "input",
					width = "full",
					name = L["Set Name"],
					get = function()
						return setName
					end,
					set = function(_, value)
						if value == setName then
							return
						end
						private:RenameBindingSet(setName, value)
						private:RefreshOptions("bindingSets", value)
					end,
					validate = function(_, value)
						return not private:BindingSetExists(value) or L["Duplicate binding set name."]
					end,
				},
				load = {
					order = 2,
					type = "execute",
					name = L["Load"],
					func = function()
						private:LoadBindingSet(setName)
					end,
				},
				update = {
					order = 3,
					type = "execute",
					name = L["Update"],
					func = function()
						private:SaveBindingSet(setName)
						private:RefreshOptions()
						private:LoadBindingSet()
					end,
					confirm = function()
						return format(L["Are you sure you want to overwrite %s?"], setName)
					end,
				},
				delete = {
					order = 4,
					type = "execute",
					name = L["Delete"],
					func = function()
						private:DeleteBindingSet(setName)
						private:RefreshOptions()
					end,
					confirm = function()
						return format(L["Are you sure you want to delete %s?"], setName)
					end,
				},
			},
		}
	end

	return options
end

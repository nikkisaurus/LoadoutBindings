local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local ACD = LibStub("AceConfigDialog-3.0")

function private:CloseOptions()
	ACD:Close(addonName)
end

function private:GetConfigOptions()
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
		rename = {
			order = 2,
			type = "input",
			name = function()
				return format(L["Renaming %s"], private.renaming or "")
			end,
			hidden = function()
				return not private.renaming
			end,
			get = function()
				return private.renaming
			end,
			set = function(_, value)
				if value == private.renaming then
					private.renaming = nil
					private:RefreshOptions()
				end
				private:RenameBindingSet(private.renaming, value)
				private.renaming = nil
				private:RefreshOptions()
			end,
			validate = function(_, value)
				return value == private.renaming
					or not private:BindingSetExists(value)
					or L["Duplicate binding set name."]
			end,
		},
		renameSets = {
			order = 3,
			type = "select",
			style = "dropdown",
			name = L["Rename"],
			values = private:GetBindingSetNames(),
			set = function(_, value)
				private.renaming = value
				private:RefreshOptions()
			end,
		},
		deleteSets = {
			order = 4,
			type = "select",
			style = "dropdown",
			name = L["Delete"],
			values = private:GetBindingSetNames(),
			set = function(_, value)
				private:DeleteBindingSet(value)
				private:RefreshOptions()
			end,
			confirm = function(_, value)
				return format(L["Are you sure you want to delete %s?"], value)
			end,
		},
	}

	return options
end

function private:GetOptions()
	private.options = {
		type = "group",
		name = L.addonName,
		args = {
			config = {
				order = 1,
				type = "group",
				name = L["Config"],
				args = private:GetConfigOptions(),
			},
			profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(private.db),
		},
	}

	private.options.args.profiles.order = 2

	return private.options
end

function private:InitializeOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, private:GetOptions())
	ACD:SetDefaultSize(addonName, 850, 600)
end

function private:LoadOptions(...)
	private:SelectOptionsPath(...)
	ACD:Open(addonName)
end

function private:NotifyChange()
	LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
	LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName .. "ObjectiveEditor")
end

function private:RefreshOptions(...)
	private:UpdateGUI()

	if not private.options then
		return
	end

	if private.options.args.config then
		private.options.args.config.args = private:GetConfigOptions()
	end

	if ... then
		private:SelectOptionsPath(...)
	end

	private:NotifyChange()
end

function private:SelectOptionsPath(...)
	ACD:SelectGroup(addonName, ...)
end

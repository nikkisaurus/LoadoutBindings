local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local ACD = LibStub("AceConfigDialog-3.0")

function private:CloseOptions()
	ACD:Close(addonName)
end

function private:GetOptions()
	private.options = {
		type = "group",
		name = L.addonName,
		args = {
			bindingSets = {
				order = 1,
				type = "group",
				name = L["Binding Sets"],
				args = private:GetBindingSetsOptions(),
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
	ACD:Open(addonName, private.frame)
end

function private:NotifyChange()
	LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
	LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName .. "ObjectiveEditor")
end

function private:RefreshOptions(...)
	if not private.options then
		return
	end

	if private.options.args.bindingSets then
		private.options.args.bindingSets.args = private:GetBindingSetsOptions()
	end

	if ... then
		private:SelectOptionsPath(...)
	end

	private:NotifyChange()
end

function private:SelectOptionsPath(...)
	ACD:SelectGroup(addonName, ...)
end

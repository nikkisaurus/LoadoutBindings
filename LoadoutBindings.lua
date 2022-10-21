local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
function addon:OnInitialize()
	private.db = LibStub("AceDB-3.0"):New("LoadoutBindingsDB", {
		global = {
			bindingSets = {},
			loadouts = {},
		},
	})

	addon:RegisterChatCommand("loadoutbindings", "HandleSlashCommand")
	addon:RegisterChatCommand("lbinds", "HandleSlashCommand")
end

function addon:OnEnable()
	-- addon.ACTIVE_PLAYER_SPECIALIZATION_CHANGED = private.LoadBindingSet
	addon.TRAIT_CONFIG_UPDATED = private.LoadBindingSet
	addon.TRAIT_TREE_CHANGED = private.LoadBindingSet

	addon:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
	addon:RegisterEvent("TRAIT_CONFIG_UPDATED")
	addon:RegisterEvent("TRAIT_TREE_CHANGED")

	EventUtil.ContinueOnAddOnLoaded("Blizzard_ClassTalentUI", function()
		private:InitializeGUI()
	end)
end

function addon:OnDisable()
	addon:UnregisterAllEvents()
end

function addon:HandleSlashCommand(input)
	input = input and input:trim() or ""
	local cmd, arg = strsplit(" ", input)
	if cmd == "" then
		-- TODO: show GUI
	elseif cmd == "save" then
		if not arg or arg == "" then
			self:Print(L["Invalid binding set name."])
			return
		elseif private.db.global.bindingSets[arg] then
			self:Print(L["Duplicate binding set name."])
			return
		end
		private:SaveBindingSet(arg)
	end
end

function addon:ACTIVE_PLAYER_SPECIALIZATION_CHANGED()
	ClassTalentFrame.TabSystem:SetTab(2)
	private:LoadBindingSet()
end

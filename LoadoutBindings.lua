local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

function addon:OnInitialize()
	private:InitializeDatabase()
	private:InitializeSlashCommands()
	private:InitializeOptions()
end

function addon:OnEnable()
	private:RegisterEvents()
	EventUtil.ContinueOnAddOnLoaded("Blizzard_ClassTalentUI", function()
		private:InitializeGUI()

		local selectionID = ClassTalentFrame.TalentsTab.LoadoutDropDown:GetSelectionID()
			or (C_ClassTalents:GetStarterBuildActive() and -2)
		private.db.char.activeLoadouts[private:GetSpecID()] = selectionID
	end)
end

function addon:OnDisable()
	addon:UnregisterAllEvents()
end

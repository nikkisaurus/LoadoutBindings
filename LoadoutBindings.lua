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
		local frame = private.frame or LibStub("AceGUI-3.0"):Create("InlineGroup")
		frame.frame:SetParent(ClassTalentFrame)
		frame.frame:SetPoint("TOPLEFT", ClassTalentFrame, "TOPLEFT", 40, -40)
		frame.frame:SetPoint("BOTTOMRIGHT", ClassTalentFrame, "BOTTOMRIGHT", -40, 40)
		frame.frame:Hide()
		private.frame = frame

		frame.frame:SetScript("OnShow", function()
			private:LoadOptions()
		end)

		ClassTalentFrame.lbTabID = ClassTalentFrame:AddNamedTab(L.addonName, frame.frame)
		addon:SecureHook(ClassTalentFrame, "UpdateFrameTitle", function()
			if ClassTalentFrame:GetTab() == ClassTalentFrame.lbTabID then
				ClassTalentFrame:SetTitle(L.addonName)
			end
		end)

		private:InitializeGUI()

		local selectionID = ClassTalentFrame.TalentsTab.LoadoutDropDown:GetSelectionID()
			or (C_ClassTalents:GetStarterBuildActive() and -2)
		private.db.char.activeLoadouts[private:GetSpecID()] = selectionID
	end)
end

function addon:OnDisable()
	addon:UnregisterAllEvents()
end

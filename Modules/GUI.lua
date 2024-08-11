local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local AceGUI = LibStub("AceGUI-3.0")

function private:GetBindingSetNames()
	local sets = {}

	for setName, _ in pairs(private.db.global.bindingSets) do
		sets[setName] = setName
	end

	return sets
end

function private:InitializeGUI()
	local tabFrame = PlayerSpellsFrame.TalentsFrame

	private:InitializeLoadouts()

	local group = AceGUI:Create("InlineGroup")
	group.frame:SetParent(tabFrame)
	group:SetPoint("TOP", 0, -25)
	group.frame:SetFrameStrata("DIALOG")
	group:SetWidth(200)
	group:SetHeight(200)
	group:SetTitle(L.addonName)
	group.titletext:SetJustifyH("CENTER")

	group.frame:SetScript("OnShow", function(self)
		private:UpdateGUI()
	end)

	local bindingSets = AceGUI:Create("Dropdown")
	bindingSets:SetFullWidth(true)
	bindingSets:SetLabel(L["Loadout"])
	group:AddChild(bindingSets)

	bindingSets:SetCallback("OnValueChanged", function(_, _, value)
		private.db.char.loadouts[private:GetSpecID()][tabFrame.LoadSystem:GetLastValidSelectionID()] = value
		private:LoadBindingSet(value)
	end)

	private.GUI = {
		group = group,
		bindingSets = bindingSets,
	}

	private:UpdateGUI()

	addon:SecureHook(tabFrame.LoadSystem, "SetSelectionID", function(_, selectionID)
		private.db.char.activeLoadouts[private:GetSpecID()] = selectionID
	end)
end

function private:UpdateGUI()
	private.GUI.bindingSets:SetList(private:GetBindingSetNames())

	local selectionID = PlayerSpellsFrame.TalentsFrame.LoadSystem:GetLastValidSelectionID()
		or (C_ClassTalents:GetStarterBuildActive() and -2)
	private.GUI.bindingSets:SetValue(private.db.char.loadouts[private:GetSpecID()][selectionID])
end

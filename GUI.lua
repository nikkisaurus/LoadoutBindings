local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local AceGUI = LibStub("AceGUI-3.0")

function private:InitializeGUI()
	local tabFrame = ClassTalentFrame.TalentsTab
	local loadout = tabFrame.LoadoutDropDown

	-- Widgets
	local group = AceGUI:Create("InlineGroup")
	group:SetTitle(L.addonName)
	group.titletext:SetJustifyH("CENTER")
	group.frame:SetParent(tabFrame)
	group:SetPoint("TOP", tabFrame, "TOP", 0, -25)
	group:SetWidth(200)
	group:SetHeight(200)
	group.frame:SetFrameStrata("DIALOG")

	local newBindingSet = AceGUI:Create("EditBox")
	newBindingSet:SetFullWidth(true)
	newBindingSet:SetLabel(L["New Binding Set"])
	group:AddChild(newBindingSet)

	local bindingSets = AceGUI:Create("Dropdown")
	bindingSets:SetLabel(L["Loadout"])
	bindingSets:SetFullWidth(true)
	bindingSets:SetList(private:GetBindingSetNames())
	group:AddChild(bindingSets)

	local deleteBindingSet = AceGUI:Create("Dropdown")
	deleteBindingSet:SetLabel(L["Delete Binding Set"])
	deleteBindingSet:SetFullWidth(true)
	deleteBindingSet:SetList(private:GetBindingSetNames())
	group:AddChild(deleteBindingSet)

	-- Callbacks
	newBindingSet:SetCallback("OnEnterPressed", function(_, _, value)
		if not private.db.global.bindingSets[value] then
			private:SaveBindingSet(value)
			bindingSets:SetList(private:GetBindingSetNames())
			deleteBindingSet:SetList(private:GetBindingSetNames())
			newBindingSet:SetText("")
		else
			addon:Print(L["Duplicate binding set name."])
		end
	end)

	bindingSets.frame:SetScript("OnShow", function(self)
		self.obj:SetValue(private.db.global.loadouts[loadout:GetSelectionID()])
	end)

	bindingSets:SetCallback("OnValueChanged", function(_, _, value)
		private.db.global.loadouts[loadout:GetSelectionID()] = value
		private:LoadBindingSet(true)
	end)

	deleteBindingSet:SetCallback("OnValueChanged", function(_, _, value)
		for selectionID, bindingSetName in pairs(private.db.global.loadouts) do
			if bindingSetName == value then
				if loadout:GetSelectionID() == selectionID then
					bindingSets:SetValue()
				end
				private.db.global.loadouts[selectionID] = nil
			end
		end

		private.db.global.bindingSets[value] = nil
		bindingSets:SetList(private:GetBindingSetNames())
		deleteBindingSet:SetList(private:GetBindingSetNames())
		deleteBindingSet:SetValue()
	end)

	addon:SecureHook(loadout, "SetSelectionID", function(_, selectionID)
		bindingSets:SetValue(private.db.global.loadouts[selectionID])
	end)
end

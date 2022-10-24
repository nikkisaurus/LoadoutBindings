local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

function private:GetSpecID()
	return (GetSpecializationInfo(GetSpecialization()))
end

function private:InitializeDatabase()
	private.db = LibStub("AceDB-3.0"):New("LoadoutBindingsDB", {
		global = {
			bindingSets = {},
		},
		char = {
			activeLoadouts = {},
			loadouts = {},
		},
	})
end

function private:InitializeLoadouts()
	local specID = private:GetSpecID()
	local configIDs = C_ClassTalents.GetConfigIDsBySpecID(specID)

	private.db.char.loadouts[specID] = private.db.char.loadouts[specID] or {}

	for _, configID in pairs(configIDs) do
		private.db.char.loadouts[specID][configID] = private.db.char.loadouts[specID][configID] or false
	end

	C_Timer.After(0.1, function()
		private.db.char.activeLoadouts[specID] = ClassTalentFrame.TalentsTab.LoadoutDropDown:GetSelectionID()
	end)
end

function private:InitializeSlashCommands()
	local HandleSlashCommand = function(input)
		input = input and input:trim() or ""
		local cmd, arg, arg2 = strsplit(" ", input)
		if cmd == "" then
		-- TODO: show GUI
		elseif cmd == "save" then
			if not arg or arg == "" then
				self:Print(L["Invalid binding set name."])
				return
			elseif private.db.global.bindingSets[arg] and not arg2 then
				self:Print(L["Duplicate binding set name."])
				return
			end
			private:SaveBindingSet(arg)
		end
	end
	addon:RegisterChatCommand("loadoutbindings", HandleSlashCommand)
	addon:RegisterChatCommand("lbinds", HandleSlashCommand)
end

function private:RegisterEvents()
	addon:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
	addon:RegisterEvent("TRAIT_CONFIG_CREATED")
	addon:RegisterEvent("TRAIT_CONFIG_DELETED")
	addon:RegisterEvent("TRAIT_CONFIG_UPDATED")
	addon:RegisterEvent("TRAIT_TREE_CHANGED")
end

function addon:ACTIVE_PLAYER_SPECIALIZATION_CHANGED()
	-- Update configIDs
	private:InitializeLoadouts()
	-- Refresh bindingSets dropdown
	private:UpdateGUI()
	-- Load bindingSet
	private:LoadBindingSet()
end

function addon:TRAIT_CONFIG_CREATED()
	-- Update configIDs
	private:InitializeLoadouts()
end

function addon:TRAIT_CONFIG_DELETED(_, selectionID)
	-- Remove from char loadouts db
	private.db.char.loadouts[private:GetSpecID()][selectionID] = nil

	-- If selection is active, update activeLoadouts
	if private.db.char.activeLoadouts[specID] == selectionID then
		private.db.char.activeLoadouts[specID] = ClassTalentFrame.TalentsTab.LoadoutDropDown:GetSelectionID()
			or (C_ClassTalents:GetStarterBuildActive() and -2)
	end
end

function addon:TRAIT_CONFIG_UPDATED()
	-- Fires when loadout has finished
	private:LoadBindingSet()
end

function addon:TRAIT_TREE_CHANGED()
	-- Fires when loadout activating
	private:UpdateGUI()
end

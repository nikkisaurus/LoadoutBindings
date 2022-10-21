local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

function private:GetBindingSetNames()
	local sets = {}

	for setName, _ in pairs(private.db.global.bindingSets) do
		sets[setName] = setName
	end

	return sets
end

function private:SaveBindingSet(setName)
	private.db.global.bindingSets[setName] = {}
	local set = private.db.global.bindingSets[setName]

	for i = 1, GetNumBindings() do
		local binding = { GetBinding(i) }
		if binding[3] then
			set[binding[1]] = { select(3, unpack(binding)) }
		end
	end
end

function private:LoadBindingSet(override)
	local selectionID = ClassTalentFrame.TalentsTab.LoadoutDropDown:GetSelectionID()
	local set = private.db.global.bindingSets[private.db.global.loadouts[selectionID]]

	if (private.selectionID == selectionID and not override) or not set then
		return
	end

	private.selectionID = selectionID

	for i = 1, GetNumBindings() do
		local binding = { GetBinding(i) }
		if binding[3] then
			for _, key in pairs({ select(3, unpack(binding)) }) do
				SetBinding(key)
			end
		end
	end

	for cmd, binds in pairs(set) do
		for _, key in pairs(binds) do
			SetBinding(key, cmd)
		end
	end

	SaveBindings(GetCurrentBindingSet())
end

local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

function private:BindingSetExists(setName)
	return private.db.global.bindingSets[setName]
end

function private:DeleteBindingSet(setName)
	private.db.global.bindingSets[setName] = nil

	for charKey, charDB in pairs(LoadoutBindingsDB.char) do
		for specID, configIDs in pairs(charDB.loadouts) do
			for configID, loadout in pairs(configIDs) do
				if loadout == setName then
					LoadoutBindingsDB.char[charKey].loadouts[specID][configID] = false
				end
			end
		end
	end
end

function private:SaveBindingSet(setName)
	private.db.global.bindingSets[setName] = {}

	for i = 1, GetNumBindings() do
		local binding = { GetBinding(i) }
		if binding[3] then
			private.db.global.bindingSets[setName][binding[1]] = { select(3, unpack(binding)) }
		end
	end
end

function private:LoadBindingSet()
	local specID = private:GetSpecID()
	local activeSet = private.db.char.activeLoadouts[specID]
	local loadout = activeSet and private.db.char.loadouts[specID][activeSet]
	local bindingSet = loadout and private.db.global.bindingSets[loadout]
	if not bindingSet then
		return
	end

	-- Clear bindings
	for i = 1, GetNumBindings() do
		local binding = { GetBinding(i) }
		if binding[3] then
			for _, key in pairs({ select(3, unpack(binding)) }) do
				SetBinding(key)
			end
		end
	end

	-- Set bindings
	for cmd, binds in pairs(bindingSet) do
		for _, key in pairs(binds) do
			SetBinding(key, cmd)
		end
	end

	SaveBindings(GetCurrentBindingSet())
end

function private:RenameBindingSet(currentName, newName)
	private.db.global.bindingSets[newName] = addon:CloneTable(private.db.global.bindingSets[currentName])

	for charKey, charDB in pairs(LoadoutBindingsDB.char) do
		for specID, configIDs in pairs(charDB.loadouts) do
			for configID, loadout in pairs(configIDs) do
				if loadout == currentName then
					LoadoutBindingsDB.char[charKey].loadouts[specID][configID] = newName
				end
			end
		end
	end

	private:DeleteBindingSet(currentName)
end

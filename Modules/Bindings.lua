local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

function private:SaveBindingSet(setName)
	-- private.db.global.bindingSets[setName] = {}
	-- local set = private.db.global.bindingSets[setName]

	-- for i = 1, GetNumBindings() do
	-- 	local binding = { GetBinding(i) }
	-- 	if binding[3] then
	-- 		set[binding[1]] = { select(3, unpack(binding)) }
	-- 	end
	-- end
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

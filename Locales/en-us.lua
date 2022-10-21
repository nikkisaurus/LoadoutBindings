local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)
LibStub("LibAddonUtils-2.0"):Embed(addon)

L.addonName = "Loadout Bindings"

L["Config"] = true
L["Delete Binding Set"] = true
L["Duplicate binding set name."] = true
L["Invalid binding set name."] = true
L["Loadout"] = true
L["New Binding Set"] = true

local addonName, private = ...
local addon = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)
LibStub("LibAddonUtils-2.0"):Embed(addon)

L.addonName = "Loadout Bindings"

L["Are you sure you want to delete %s?"] = true
L["Are you sure you want to overwrite %s?"] = true
L["Binding Sets"] = true
L["Config"] = true
L["Delete"] = true
L["Duplicate binding set name."] = true
L["Invalid binding set name."] = true
L["Load"] = true
L["Loadout"] = true
L["Rename"] = true
L["Renaming %s"] = true
L["Save Set"] = true
L["Set Name"] = true
L["New Binding Set"] = true
L["Update"] = true

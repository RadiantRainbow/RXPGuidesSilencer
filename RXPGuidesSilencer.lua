local addonName, addon = ...

-- All settings that cause RXPGuides to send emotes/party/guild messages
local SILENCE_KEYS = {
    "enableLevelUpAnnounceSolo",
    "enableLevelUpAnnounceGroup",
    "enableLevelUpAnnounceGuild",
    "enableCompleteStepAnnouncements",
    "enableCollectStepAnnouncements",
    "enableFlyStepAnnouncements",
    "alwaysSendBranded",
    "checkVersions",
    "shareQuests",
    "shareActiveSteps",
}

local function getRXPAddon()
    local AceAddon = LibStub and LibStub("AceAddon-3.0", true)
    if not AceAddon then return nil end

    -- Try the common internal names for the RXPGuides addon object
    return AceAddon:GetAddon("RXPGuides", true)
        or AceAddon:GetAddon("RestedXP Guides", true)
        or AceAddon:GetAddon("RestedXP", true)
end

local function silenceRXP()
    local rxp = getRXPAddon()
    if not rxp or not rxp.settings or not rxp.settings.profile then return end

    local profile = rxp.settings.profile
    for _, key in ipairs(SILENCE_KEYS) do
        profile[key] = false
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", silenceRXP)

-- Re-enforce every second; RXP's groupMode toggle re-enables some of these,
-- and this prevents any manual UI toggle from re-enabling them mid-session.
local elapsed = 0
frame:SetScript("OnUpdate", function(self, delta)
    elapsed = elapsed + delta
    if elapsed >= 5 then
        elapsed = 0
        silenceRXP()
    end
end)

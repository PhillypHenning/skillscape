local _, ns = ...

-- The RuneScape-style level-up box: beige chatbox panel, dark blue headline,
-- "Click here to continue". Fades out on its own after a few seconds.

local VISIBLE_SECONDS = 4
local FADE_SECONDS = 1

local popup = CreateFrame("Button", "SkillScapePopup", UIParent, "BackdropTemplate")
popup:SetSize(460, 100)
popup:SetPoint("BOTTOM", 0, 180)
popup:SetFrameStrata("DIALOG")
popup:SetBackdrop({
	bgFile = "Interface\\Buttons\\WHITE8X8",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 14,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
})
popup:SetBackdropColor(0.83, 0.77, 0.63, 0.95)
popup:SetBackdropBorderColor(0.35, 0.29, 0.2, 1)
popup:Hide()

popup.title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
popup.title:SetPoint("TOP", 0, -16)
popup.title:SetTextColor(0, 0, 0.5)

popup.detail = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
popup.detail:SetPoint("TOP", popup.title, "BOTTOM", 0, -8)
popup.detail:SetTextColor(0, 0, 0)

popup.continue = popup:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
popup.continue:SetPoint("BOTTOM", 0, 12)
popup.continue:SetTextColor(0, 0, 0.8)
popup.continue:SetText("Click here to continue")

local fade = popup:CreateAnimationGroup()
local alpha = fade:CreateAnimation("Alpha")
alpha:SetFromAlpha(1)
alpha:SetToAlpha(0)
alpha:SetStartDelay(VISIBLE_SECONDS)
alpha:SetDuration(FADE_SECONDS)
fade:SetScript("OnFinished", function() popup:Hide() end)

popup:SetScript("OnClick", function()
	fade:Stop()
	popup:Hide()
end)

function ns.ShowPopup(title, detail)
	popup.title:SetText(title)
	popup.detail:SetText(detail)
	fade:Stop()
	popup:SetAlpha(1)
	popup:Show()
	fade:Play()
end

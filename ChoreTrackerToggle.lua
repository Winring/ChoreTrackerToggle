-- Last command (whether "show" or "hide" was called last)
local lastCommand = "hide"

-- Function that executes the slash command
local function ToggleChoreTracker()
    if lastCommand == "hide" then
        lastCommand = "show"
        ChatFrame1EditBox:SetText("/choretracker show")
        ChatEdit_SendText(ChatFrame1EditBox)
    else
        lastCommand = "hide"
        ChatFrame1EditBox:SetText("/choretracker hide")
        ChatEdit_SendText(ChatFrame1EditBox)
    end
end

local function ToggleChoreTrackerSettings()
	ChatFrame1EditBox:SetText("/choretracker")
    ChatEdit_SendText(ChatFrame1EditBox)
    
end

-- Create a button on the minimap
local button = CreateFrame("Button", "ChoreTrackerMinimapButton", Minimap)
button:SetSize(31, 31)  -- Set the button size
button:SetFrameStrata("MEDIUM")
button:SetFrameLevel(8)
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight") -- Highlight on hover

-- Icon for the button
local icon = button:CreateTexture(nil, "BACKGROUND")
icon:SetTexture("Interface\\Icons\\INV_Misc_Note_05")  -- Hearthstone icon (can be changed as needed)
icon:SetSize(20, 20)
icon:SetPoint("CENTER")

-- Circle around the icon so the button behaves like other minimap buttons
local border = button:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetSize(53, 53)
border:SetPoint("TOPLEFT")

-- Function for clicking the button
button:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        ToggleChoreTracker()
    end
	if button == "RightButton" then
        ToggleChoreTrackerSettings()
    end
end)

-- Function to get the position of the button **outside** the minimap
local function UpdateButtonPosition(angle)
    local radius = 90  -- Increased radius for position **outside** the minimap
    local x = cos(angle) * radius
    local y = sin(angle) * radius
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Store the angle of the button's position (you can change the default value)
local minimapButtonAngle = 45

-- Přidání tooltipu
button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine("ChoreTrackerToggle", 1, 0.82, 0)
    GameTooltip:AddLine("|cff00ff00Click left|r for show/hide ChoreTracker", 1, 1, 1)
    GameTooltip:AddLine("|cff00ff00Click right|r for ChoreTracker settings", 1, 1, 1)
    GameTooltip:Show()
end)

button:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Initialize the button's position
UpdateButtonPosition(minimapButtonAngle)

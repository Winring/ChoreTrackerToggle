-- Last command (whether "show" or "hide" was called last)
local lastCommand = "hide"
-- Store the angle of the button's position (you can change the default value)
local minimapButtonAngle = 45
-- Value for keeping info about if draggign is in progress
local isDragging = false


-- UI
-- Create a button on the minimap
local button = CreateFrame("Button", "ChoreTrackerMinimapButton", Minimap)
button:SetSize(33, 32)  -- Set the button size
button:SetFrameStrata("MEDIUM")
button:SetFrameLevel(8)
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight") -- Highlight on hover

-- Icon for the button
local icon = button:CreateTexture(nil, "BACKGROUND")
icon:SetTexture("Interface\\Addons\\ChoreTrackerToggle\\ChoreTrackerToggle.jpg")
icon:SetSize(20, 20)
icon:SetPoint("CENTER")

-- Adding tooltip
button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine("ChoreTrackerToggle", 1, 0.82, 0)
    GameTooltip:AddLine("|cff00ff00Click left|r for show/hide ChoreTracker", 1, 1, 1)
    GameTooltip:AddLine("|cff00ff00Click right|r for ChoreTracker settings", 1, 1, 1)
	GameTooltip:AddLine("|cff00ff00Drag right|r change ChoreTrackerToggle button position", 1, 1, 1)
    GameTooltip:Show()
end)
button:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Circle around the icon so the button behaves like other minimap buttons
local border = button:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetSize(53, 53)
border:SetPoint("TOPLEFT")

-- Function to update the position of the button around the minimap
local function UpdateButtonPosition(angle)
    local radius = 100
    local x = cos(angle) * radius
    local y = sin(angle) * radius

    -- Clear any existing points to avoid conflicts
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end


-- Function to calculate angle based on cursor position
local function CalculateAngle()
    local centerX, centerY = Minimap:GetCenter()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    x, y = x / scale, y / scale  -- Adjust for UI scale
    local dx, dy = x - centerX, y - centerY
    return math.deg(math.atan2(dy, dx))
end

-- Draggable feature for moving the button
button:SetMovable(true)
button:EnableMouse(true)
button:RegisterForDrag("RightButton")
button:SetScript("OnDragStart", function(self)
    isDragging = true  -- Nastavení na drag režim
    self:SetScript("OnUpdate", function()
        minimapButtonAngle = CalculateAngle()
        if minimapButtonAngle < 0 then
            minimapButtonAngle = minimapButtonAngle + 360
        end
        UpdateButtonPosition(minimapButtonAngle)
    end)
end)
button:SetScript("OnDragStop", function(self)
    isDragging = false  -- Ukončení drag režimu
    self:SetScript("OnUpdate", nil)
end)

-- Initialize the button's position
UpdateButtonPosition(minimapButtonAngle)

-- Functions
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

-- Function that executes slash command for settings
local function ToggleChoreTrackerSettings()
	ChatFrame1EditBox:SetText("/choretracker")
    ChatEdit_SendText(ChatFrame1EditBox)
    
end

-- Function for clicking the button
button:SetScript("OnMouseUp", function(self, button)
    if not isDragging then
		if button == "LeftButton" then
			ToggleChoreTracker()
		end
		if button == "RightButton" then
			ToggleChoreTrackerSettings()
		end
	end
end)

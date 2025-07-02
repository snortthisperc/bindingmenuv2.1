--[[
    File for settings menu, majority can go untouched unless adding your own settings or altering default profiles/rank limits.
                                                                                                                                ]]--

KEYBIND.Settings = KEYBIND.Settings or {}

-- Default settings configuration
KEYBIND.Settings.Config = {
    showFeedback = true
    -- Add any other settings here
}

-- Create fonts for the settings menu
surface.CreateFont("KeybindSettingsTitle", {
    font = "Roboto",
    size = 22,
    weight = 600,
    antialias = true
})

surface.CreateFont("KeybindSettingsHeader", {
    font = "Roboto",
    size = 18,
    weight = 600,
    antialias = true
})

surface.CreateFont("KeybindSettingsText", {
    font = "Roboto",
    size = 16,
    weight = 500,
    antialias = true
})

surface.CreateFont("KeybindSettingsButton", {
    font = "Roboto",
    size = 15,
    weight = 500,
    antialias = true
})

-- Settings Save/Load Functions
function KEYBIND.Settings:SaveSettings()
    local data = {
        showFeedback = self.Config.showFeedback
        -- Add other settings here
    }
    
    file.CreateDir("bindmenu")
    file.Write("bindmenu/settings.txt", util.TableToJSON(data, true))
    print("[BindMenu] Saved settings to disk")
end

function KEYBIND.Settings:LoadSettings()
    local data = file.Read("bindmenu/settings.txt", "DATA")
    if data then
        local settings = util.JSONToTable(data)
        if settings then
            self.Config = settings
        end
    end
end

-- Initialize settings
hook.Add("Initialize", "KEYBIND_Settings_Init", function()
    KEYBIND.Settings:LoadSettings()
end)

-- Save settings on shutdown
hook.Add("ShutDown", "KEYBIND_Settings_Save", function()
    if KEYBIND and KEYBIND.Settings then
        KEYBIND.Settings:SaveSettings()
    end
end)

-- Main settings menu
function KEYBIND.Settings:Create()
    if IsValid(self.Frame) then
        self.Frame:Remove()
    end

    -- Create the main frame
    self.Frame = vgui.Create("DFrame")
    self.Frame:SetSize(550, 600)
    self.Frame:Center()
    self.Frame:SetTitle("")
    self.Frame:MakePopup()
    self.Frame:ShowCloseButton(false)
    self.Frame:SetDraggable(true)
    
    -- Modern dark theme with blur
    self.Frame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, 0)
        
        -- Main background
        draw.RoundedBox(10, 0, 0, w, h, Color(25, 25, 30, 245))
        
        -- Top accent bar
        draw.RoundedBoxEx(10, 0, 0, w, 50, Color(40, 90, 140), true, true, false, false)
        
        -- Title with shadow
        draw.SimpleText("Bind Menu Settings", "KeybindSettingsTitle", 25, 25, Color(0, 0, 0, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Bind Menu Settings", "KeybindSettingsTitle", 24, 24, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Modern close button
    local closeBtn = vgui.Create("DButton", self.Frame)
    closeBtn:SetSize(36, 36)
    closeBtn:SetPos(self.Frame:GetWide() - 46, 7)
    closeBtn:SetText("")
    closeBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local color = hovered and Color(255, 80, 80, 200) or Color(255, 255, 255, 30)
        
        draw.RoundedBox(8, 0, 0, w, h, color)
        
        -- X icon
        local padding = 12
        local color = hovered and Color(255, 255, 255) or Color(220, 220, 220)
        
        surface.SetDrawColor(color)
        surface.DrawLine(padding, padding, w-padding, h-padding)
        surface.DrawLine(w-padding, padding, padding, h-padding)
    end
    closeBtn.DoClick = function() self.Frame:Remove() end
    
    -- Create scroll panel for settings
    local scroll = vgui.Create("DScrollPanel", self.Frame)
    scroll:Dock(FILL)
    scroll:DockMargin(20, 60, 20, 60)
    
    -- Custom scrollbar
    local scrollbar = scroll:GetVBar()
    scrollbar:SetWide(6)
    scrollbar.Paint = function(self, w, h) end
    scrollbar.btnUp.Paint = function(self, w, h) end
    scrollbar.btnDown.Paint = function(self, w, h) end
    scrollbar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 40))
    end
    
    -- Add general settings section
    self:AddGeneralSettings(scroll)
    
    -- Add keyboard layout settings section
    self:AddKeyboardLayoutSettings(scroll)
    
    -- Add profile settings sections
    self:AddProfileSettings(scroll)
    
    -- Add reset all button
    local resetAllBtn = vgui.Create("DButton", self.Frame)
    resetAllBtn:SetSize(200, 40)
    resetAllBtn:SetPos(self.Frame:GetWide()/2 - 100, self.Frame:GetTall() - 50)
    resetAllBtn:SetText("")
    
    resetAllBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local baseColor = hovered and Color(200, 60, 60) or Color(170, 50, 50)
        
        draw.RoundedBox(8, 0, 0, w, h, baseColor)
        
        -- Add subtle gradient
        surface.SetDrawColor(255, 255, 255, 15)
        surface.SetMaterial(Material("gui/gradient_up"))
        surface.DrawTexturedRect(0, 0, w, h)
        
        -- Add text with shadow
        draw.SimpleText("Reset All Profiles", "KeybindSettingsButton", w/2+1, h/2+1, Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Reset All Profiles", "KeybindSettingsButton", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    resetAllBtn.DoClick = function()
        Derma_Query(
            "Are you sure you want to reset ALL profiles?\nThis cannot be undone!",
            "Confirm Reset",
            "Yes", function() self:DeleteAllProfiles() end,
            "No", function() end
        )
    end
end

function KEYBIND.Settings:AddGeneralSettings(parent)
    local panel = vgui.Create("DPanel", parent)
    panel:Dock(TOP)
    panel:SetHeight(100)
    panel:DockMargin(0, 0, 0, 20)
    
    panel.Paint = function(self, w, h)
        -- Card background with subtle shadow
        draw.RoundedBox(8, 2, 2, w-4, h-4, Color(0, 0, 0, 50))
        draw.RoundedBox(8, 0, 0, w, h, Color(35, 35, 40))
        
        -- Card header
        draw.RoundedBoxEx(8, 0, 0, w, 36, Color(45, 45, 50), true, true, false, false)
        
        -- Header text with shadow
        draw.SimpleText("General Settings", "KeybindSettingsHeader", 15, 18, Color(0, 0, 0, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("General Settings", "KeybindSettingsHeader", 14, 17, Color(230, 230, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Feedback checkbox with modern styling
    local feedbackCheck = vgui.Create("DCheckBoxLabel", panel)
    feedbackCheck:SetPos(20, 55)
    feedbackCheck:SetText("Show Feedback Messages")
    feedbackCheck:SetTextColor(Color(210, 210, 210))
    feedbackCheck:SetFont("KeybindSettingsText")
    feedbackCheck:SizeToContents()
    feedbackCheck:SetValue(self.Config.showFeedback)
    
    feedbackCheck.OnChange = function(self, val)
        KEYBIND.Settings.Config.showFeedback = val
        KEYBIND.Settings:SaveSettings()
        
        if val then
            chat.AddText(Color(0, 255, 0), "[BindMenu] Feedback messages enabled")
        else
            chat.AddText(Color(255, 0, 0), "[BindMenu] Feedback messages disabled")
        end
    end
    
    -- Modern checkbox style
    feedbackCheck.Button.Paint = function(self, w, h)
        local checked = self:GetChecked()
        local hovered = self:IsHovered()
        
        local bgColor = checked and Color(60, 130, 200) or Color(45, 45, 50)
        if hovered then
            bgColor = Color(bgColor.r + 20, bgColor.g + 20, bgColor.b + 20)
        end
        
        draw.RoundedBox(4, 0, 0, w, h, bgColor)
        
        if checked then
            -- Checkmark
            surface.SetDrawColor(255, 255, 255)
            surface.DrawLine(3, h/2, w/2-1, h-3)
            surface.DrawLine(w/2-1, h-3, w-3, 3)
        end
    end
end

function KEYBIND.Settings:AddProfileSettings(parent)
    local userGroup = LocalPlayer():GetUserGroup()
    local accessLevel = 0
    
    if userGroup == "loyalty" then
        accessLevel = 2
    elseif userGroup == "premium" then
        accessLevel = 1
    end
    
    local maxProfiles = 3
    if accessLevel == 2 then
        maxProfiles = 7
    elseif accessLevel == 1 then
        maxProfiles = 5
    end
    
    -- Define base profiles with proper access levels
    local baseProfiles = {
        {name = "Profile1", displayName = "Profile 1", access = 0, color = Color(60, 130, 200)},
        {name = "Profile2", displayName = "Profile 2", access = 0, color = Color(60, 130, 200)},
        {name = "Profile3", displayName = "Profile 3", access = 0, color = Color(60, 130, 200)},
        {name = "Premium1", displayName = "Premium 4", access = 1, color = Color(200, 130, 60)},
        {name = "Premium2", displayName = "Premium 5", access = 1, color = Color(200, 130, 60)},
        {name = "Premium3", displayName = "Loyalty 6", access = 2, color = Color(130, 200, 60)},
        {name = "Premium4", displayName = "Loyalty 7", access = 2, color = Color(130, 200, 60)}
    }
    
    -- Add sections for profiles the user has access to
    for i, profileData in ipairs(baseProfiles) do
        if profileData.access <= accessLevel and i <= maxProfiles then
            self:AddProfileCard(parent, profileData.name, profileData.color)
        end
    end
end

function KEYBIND.Settings:AddProfileCard(parent, profileName, accentColor)
    local storedProfile = KEYBIND.Storage.Profiles[profileName]
    if not storedProfile then return end
    
    local displayName = storedProfile.displayName or profileName
    local isCurrentProfile = KEYBIND.Storage.CurrentProfile == profileName
    
    -- Create profile panel
    local panel = vgui.Create("DPanel", parent)
    panel:Dock(TOP)
    panel:SetHeight(120)
    panel:DockMargin(0, 0, 0, 20)
    
    panel.Paint = function(self, w, h)
        -- Card background with subtle shadow
        draw.RoundedBox(8, 2, 2, w-4, h-4, Color(0, 0, 0, 50))
        draw.RoundedBox(8, 0, 0, w, h, Color(35, 35, 40))
        
        -- Card header with accent color if current profile
        local headerColor = isCurrentProfile and accentColor or Color(45, 45, 50)
        draw.RoundedBoxEx(8, 0, 0, w, 36, headerColor, true, true, false, false)
        
        -- Header text with shadow
        draw.SimpleText(displayName, "KeybindSettingsHeader", 15, 18, Color(0, 0, 0, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(displayName, "KeybindSettingsHeader", 14, 17, Color(230, 230, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        -- Current profile indicator
        if isCurrentProfile then
            draw.SimpleText("ACTIVE", "KeybindSettingsButton", w - 15, 18, Color(0, 0, 0, 100), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw.SimpleText("ACTIVE", "KeybindSettingsButton", w - 16, 17, Color(230, 230, 230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        
        -- Profile icon
        local iconName = storedProfile.icon or profileName
        local iconMat = KEYBIND.Menu.ProfileIcons[iconName]
        
        if iconMat then
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(iconMat)
            surface.DrawTexturedRect(w - 50, 8, 20, 20)
        end
    end
    
    -- Create buttons container
    local buttonPanel = vgui.Create("DPanel", panel)
    buttonPanel:SetPos(10, 45)
    buttonPanel:SetSize(panel:GetWide() - 20, 65)
    buttonPanel:SetPaintBackground(false)
    
    -- Rename button
    local renameBtn = vgui.Create("DButton", buttonPanel)
    renameBtn:SetSize(buttonPanel:GetWide() / 3 - 7, 36)
    renameBtn:SetPos(0, 10)
    renameBtn:SetText("")
    
    renameBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local color = hovered and Color(70, 150, 220) or Color(60, 130, 200)
        
        draw.RoundedBox(6, 0, 0, w, h, color)
        
        -- Add subtle gradient
        surface.SetDrawColor(255, 255, 255, 15)
        surface.SetMaterial(Material("gui/gradient_up"))
        surface.DrawTexturedRect(0, 0, w, h)
        
        -- Text with shadow
        draw.SimpleText("Rename Profile", "KeybindSettingsButton", w/2+1, h/2+1, Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Rename Profile", "KeybindSettingsButton", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    renameBtn.DoClick = function()
        self:OpenRenameDialog(profileName, displayName)
    end
    
    -- Reset binds button
    local resetBtn = vgui.Create("DButton", buttonPanel)
    resetBtn:SetSize(buttonPanel:GetWide() / 3 - 7, 36)
    resetBtn:SetPos(buttonPanel:GetWide() / 3 + 3, 10)
    resetBtn:SetText("")
    
    resetBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local color = hovered and Color(220, 70, 70) or Color(200, 60, 60)
        
        draw.RoundedBox(6, 0, 0, w, h, color)
        
        -- Add subtle gradient
        surface.SetDrawColor(255, 255, 255, 15)
        surface.SetMaterial(Material("gui/gradient_up"))
        surface.DrawTexturedRect(0, 0, w, h)
        
        -- Text with shadow
        draw.SimpleText("Reset Binds", "KeybindSettingsButton", w/2+1, h/2+1, Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Reset Binds", "KeybindSettingsButton", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    resetBtn.DoClick = function()
        Derma_Query(
            "Are you sure you want to reset all binds for " .. displayName .. "?",
            "Confirm Reset",
            "Yes", function() self:ResetProfile(profileName) end,
            "No", function() end
        )
    end
    
    -- Choose icon button
    local iconBtn = vgui.Create("DButton", buttonPanel)
    iconBtn:SetSize(buttonPanel:GetWide() / 3 - 7, 36)
    iconBtn:SetPos(2 * (buttonPanel:GetWide() / 3) + 6, 10)
    iconBtn:SetText("")
    
    iconBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local color = hovered and Color(70, 150, 70) or Color(60, 130, 60)
        
        draw.RoundedBox(6, 0, 0, w, h, color)
        
        -- Add subtle gradient
        surface.SetDrawColor(255, 255, 255, 15)
        surface.SetMaterial(Material("gui/gradient_up"))
        surface.DrawTexturedRect(0, 0, w, h)
        
        -- Text with shadow
        draw.SimpleText("Choose Icon", "KeybindSettingsButton", w/2+1, h/2+1, Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Choose Icon", "KeybindSettingsButton", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    iconBtn.DoClick = function()
        self:OpenIconSelector(profileName, displayName)
    end
    
    -- Fix button positions after parent is fully created
    panel.PerformLayout = function(self, w, h)
        buttonPanel:SetSize(w - 20, 65)
        
        renameBtn:SetSize(buttonPanel:GetWide() / 3 - 7, 36)
        renameBtn:SetPos(0, 10)
        
        resetBtn:SetSize(buttonPanel:GetWide() / 3 - 7, 36)
        resetBtn:SetPos(buttonPanel:GetWide() / 3 + 3, 10)
        
        iconBtn:SetSize(buttonPanel:GetWide() / 3 - 7, 36)
        iconBtn:SetPos(2 * (buttonPanel:GetWide() / 3) + 6, 10)
    end
end

function KEYBIND.Settings:OpenRenameDialog(profileName, currentName)
    local dialog = vgui.Create("DFrame")
    dialog:SetSize(320, 150)
    dialog:Center()
    dialog:SetTitle("")
    dialog:MakePopup()
    dialog:ShowCloseButton(false)
    
    dialog.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, 0)
        
        -- Dialog background with shadow
        draw.RoundedBox(10, 2, 2, w-4, h-4, Color(0, 0, 0, 50))
        draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 35))
        
        -- Dialog header
        draw.RoundedBoxEx(10, 0, 0, w, 40, Color(40, 90, 140), true, true, false, false)
        
        -- Header text with shadow
        draw.SimpleText("Rename Profile", "KeybindSettingsHeader", 15, 20, Color(0, 0, 0, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Rename Profile", "KeybindSettingsHeader", 14, 19, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Modern close button
    local closeBtn = vgui.Create("DButton", dialog)
    closeBtn:SetSize(30, 30)
    closeBtn:SetPos(dialog:GetWide() - 40, 5)
    closeBtn:SetText("")
    closeBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local color = hovered and Color(255, 80, 80, 200) or Color(255, 255, 255, 30)
        
        draw.RoundedBox(8, 0, 0, w, h, color)
        
        -- X icon
        local padding = 10
        local color = hovered and Color(255, 255, 255) or Color(220, 220, 220)
        
        surface.SetDrawColor(color)
        surface.DrawLine(padding, padding, w-padding, h-padding)
        surface.DrawLine(w-padding, padding, padding, h-padding)
    end
    closeBtn.DoClick = function() dialog:Remove() end
    
    -- Modern text entry
    local textEntry = vgui.Create("DTextEntry", dialog)
    textEntry:SetPos(20, 60)
    textEntry:SetSize(dialog:GetWide() - 40, 36)
    textEntry:SetValue(currentName)
    textEntry:SelectAllText()
    
    textEntry.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Color(45, 45, 50))
        
        -- Add focus highlight
        if self:HasFocus() then
            surface.SetDrawColor(60, 130, 200)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end
        
        self:DrawTextEntryText(Color(230, 230, 230), Color(60, 130, 200), Color(230, 230, 230))
    end
    
    -- Save button
    local saveBtn = vgui.Create("DButton", dialog)
    saveBtn:SetPos(20, dialog:GetTall() - 50)
    saveBtn:SetSize(dialog:GetWide() - 40, 36)
    saveBtn:SetText("")
    
    saveBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local color = hovered and Color(70, 150, 220) or Color(60, 130, 200)
        
        draw.RoundedBox(6, 0, 0, w, h, color)
        
        -- Add subtle gradient
        surface.SetDrawColor(255, 255, 255, 15)
        surface.SetMaterial(Material("gui/gradient_up"))
        surface.DrawTexturedRect(0, 0, w, h)
        
        -- Text with shadow
        draw.SimpleText("Save", "KeybindSettingsButton", w/2+1, h/2+1, Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Save", "KeybindSettingsButton", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    saveBtn.DoClick = function()
        local newName = textEntry:GetValue()
        if newName ~= "" then
            KEYBIND.Storage:RenameProfile(profileName, newName)
            dialog:Remove()
            
            -- Refresh the settings menu
            timer.Simple(0.1, function()
                if IsValid(self.Frame) then
                    self:Create()
                end
            end)
        end
    end
end

function KEYBIND.Settings:OpenIconSelector(profileName, displayName)
    local dialog = vgui.Create("DFrame")
    dialog:SetSize(400, 350)
    dialog:Center()
    dialog:SetTitle("")
    dialog:MakePopup()
    dialog:ShowCloseButton(false)
    dialog:SetDraggable(true)
    
    dialog.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, 0)
        
        -- Dialog background with shadow
        draw.RoundedBox(10, 2, 2, w-4, h-4, Color(0, 0, 0, 50))
        draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 35))
        
        -- Dialog header
        draw.RoundedBoxEx(10, 0, 0, w, 40, Color(40, 90, 140), true, true, false, false)
        
        -- Header text with shadow
        draw.SimpleText("Choose Profile Icon: " .. displayName, "KeybindSettingsHeader", 15, 20, Color(0, 0, 0, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Choose Profile Icon: " .. displayName, "KeybindSettingsHeader", 14, 19, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Modern close button
    local closeBtn = vgui.Create("DButton", dialog)
    closeBtn:SetSize(30, 30)
    closeBtn:SetPos(dialog:GetWide() - 40, 5)
    closeBtn:SetText("")
    closeBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local color = hovered and Color(255, 80, 80, 200) or Color(255, 255, 255, 30)
        
        draw.RoundedBox(8, 0, 0, w, h, color)
        
        -- X icon
        local padding = 10
        local color = hovered and Color(255, 255, 255) or Color(220, 220, 220)
        
        surface.SetDrawColor(color)
        surface.DrawLine(padding, padding, w-padding, h-padding)
        surface.DrawLine(w-padding, padding, padding, h-padding)
    end
    closeBtn.DoClick = function() dialog:Remove() end
    
    -- Create scroll panel for icons
    local scroll = vgui.Create("DScrollPanel", dialog)
    scroll:Dock(FILL)
    scroll:DockMargin(10, 50, 10, 10)
    
    -- Custom scrollbar
    local scrollbar = scroll:GetVBar()
    scrollbar:SetWide(6)
    scrollbar.Paint = function(self, w, h) end
    scrollbar.btnUp.Paint = function(self, w, h) end
    scrollbar.btnDown.Paint = function(self, w, h) end
    scrollbar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 40))
    end
    
    local iconLayout = vgui.Create("DIconLayout", scroll)
    iconLayout:Dock(FILL)
    iconLayout:SetSpaceX(10)
    iconLayout:SetSpaceY(10)
    
    -- Get current icon
    local storedProfile = KEYBIND.Storage.Profiles[profileName]
    local currentIcon = storedProfile.icon or profileName
    
    -- Define available icons
    local availableIcons = {
        {name = "Profile1", displayName = "Default 1", category = "*"},
        {name = "Profile2", displayName = "Default 2", category = "*"},
        {name = "Profile3", displayName = "Default 3", category = "*"},
        {name = "Premium1", displayName = "Diamond Green", category = "*"},
        {name = "Premium2", displayName = "Diamond Blue", category = "*"},
        {name = "Premium3", displayName = "Diamond Orange", category = "*"},
        {name = "Premium4", displayName = "Diamond Yellow", category = "*"}
    }
    
    -- Track categories we've seen
    local categories = {}
    
    -- Add icons to grid
    for _, iconData in ipairs(availableIcons) do
        -- Add category header if we haven't seen this category yet
        if not categories[iconData.category] then
            categories[iconData.category] = true
            
            local categoryPanel = iconLayout:Add("DPanel")
            categoryPanel:SetSize(iconLayout:GetWide() - 10, 30)
            categoryPanel:SetPaintBackground(false)
            
            local categoryLabel = vgui.Create("DLabel", categoryPanel)
            categoryLabel:SetText(iconData.category .. " Icons")
            categoryLabel:SetFont("KeybindSettingsText")
            categoryLabel:SetTextColor(Color(180, 180, 180))
            categoryLabel:SizeToContents()
            categoryLabel:SetPos(5, 5)
        end
        
        -- Create icon button
        local iconBtn = iconLayout:Add("DButton")
        iconBtn:SetSize(60, 60)
        iconBtn:SetText("")
        iconBtn:SetTooltip(iconData.displayName)
        
        local iconMat = KEYBIND.Menu.ProfileIcons[iconData.name]
        local isSelected = currentIcon == iconData.name
        
        iconBtn.Paint = function(self, w, h)
            local isHovered = self:IsHovered()
            
            -- Background
            local bgColor = isSelected and Color(60, 130, 200) or (isHovered and Color(50, 50, 55) or Color(40, 40, 45))
            draw.RoundedBox(8, 0, 0, w, h, bgColor)

                        -- Icon
            if iconMat then
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(iconMat)
                surface.DrawTexturedRect(w/2 - 20, h/2 - 20, 40, 40)
            else
                -- Fallback if icon is missing
                draw.SimpleText("?", "DermaLarge", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            
            -- Selection indicator
            if isSelected then
                surface.SetDrawColor(255, 255, 255, 100)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
        end
        
        iconBtn.DoClick = function()
            -- Update profile icon
            storedProfile.icon = iconData.name
            
            -- Save to storage
            KEYBIND.Storage:SaveBinds()
            
            -- Play sound
            surface.PlaySound("buttons/button14.wav")
            
            -- Show feedback
            if KEYBIND.Settings.Config.showFeedback then
                chat.AddText(Color(0, 255, 0), "[BindMenu] Profile picture updated")
            end
            
            -- Close dialog and refresh settings
            dialog:Close()
            self:Create()
        end
    end
end

function KEYBIND.Settings:AddKeyboardLayoutSettings(parent)
    local panel = vgui.Create("DPanel", parent)
    panel:Dock(TOP)
    panel:SetHeight(150)
    panel:DockMargin(0, 0, 0, 20)
    
    panel.Paint = function(self, w, h)
        -- Card background with subtle shadow
        draw.RoundedBox(8, 2, 2, w-4, h-4, Color(0, 0, 0, 50))
        draw.RoundedBox(8, 0, 0, w, h, Color(35, 35, 40))
        
        -- Card header
        draw.RoundedBoxEx(8, 0, 0, w, 36, Color(45, 45, 50), true, true, false, false)
        
        -- Header text with shadow
        draw.SimpleText("Keyboard Layout", "KeybindSettingsHeader", 15, 18, Color(0, 0, 0, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Keyboard Layout", "KeybindSettingsHeader", 14, 17, Color(230, 230, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    -- Layout selector label
    local layoutLabel = vgui.Create("DLabel", panel)
    layoutLabel:SetPos(20, 50)
    layoutLabel:SetText("Keyboard Layout:")
    layoutLabel:SetFont("KeybindSettingsText")
    layoutLabel:SetTextColor(Color(230, 230, 230))
    layoutLabel:SizeToContents()
    
    -- Layout selector
    local layoutSelector = vgui.Create("DComboBox", panel)
    layoutSelector:SetPos(150, 50)
    layoutSelector:SetSize(200, 30)
    layoutSelector:SetValue(KEYBIND.Settings.Config.keyboardLayout or "StandardKeyboard")
    
    -- Add available layouts
    layoutSelector:AddChoice("Standard Keyboard", "StandardKeyboard")
    -- Add more layouts here as they become available
    
    layoutSelector.OnSelect = function(_, _, name, value)
        KEYBIND.Settings.Config.keyboardLayout = value
        KEYBIND.Settings:SaveSettings()
        
        -- Update the renderer
        KEYBIND.Renderer:SetLayout(value)
        
        -- Refresh the keyboard if menu is open
        if IsValid(KEYBIND.Menu.Frame) then
            KEYBIND.Menu:RefreshKeyboardLayout()
        end
    end
    
    -- Scale slider label
    local scaleLabel = vgui.Create("DLabel", panel)
    scaleLabel:SetPos(20, 90)
    scaleLabel:SetText("Keyboard Scale:")
    scaleLabel:SetFont("KeybindSettingsText")
    scaleLabel:SetTextColor(Color(230, 230, 230))
    scaleLabel:SizeToContents()
    
    -- Scale slider
    local scaleSlider = vgui.Create("DNumSlider", panel)
    scaleSlider:SetPos(150, 90)
    scaleSlider:SetSize(300, 30)
    scaleSlider:SetMin(0.5)
    scaleSlider:SetMax(1.5)
    scaleSlider:SetDecimals(1)
    scaleSlider:SetValue(KEYBIND.Settings.Config.keyboardScale or 1.0)
    
    scaleSlider.OnValueChanged = function(_, value)
        KEYBIND.Settings.Config.keyboardScale = value
        KEYBIND.Settings:SaveSettings()
        
        -- Update the renderer
        KEYBIND.Renderer:SetScale(value)
        
        -- Refresh the keyboard if menu is open
        if IsValid(KEYBIND.Menu.Frame) then
            KEYBIND.Menu:RefreshKeyboardLayout()
        end
    end
    
    return panel
end

function KEYBIND.Settings:ResetProfile(profile)
    if KEYBIND.Storage.Profiles[profile] then
        KEYBIND.Storage.Profiles[profile].binds = {}
        KEYBIND.Storage:SaveBinds()
        
        if self.Config.showFeedback then
            chat.AddText(Color(0, 255, 0), "[BindMenu] Reset all binds for profile: " .. 
                (KEYBIND.Storage.Profiles[profile].displayName or profile))
        end
        
        if IsValid(KEYBIND.Menu.Frame) then
            KEYBIND.Menu:RefreshKeyboardLayout()
        end
        
        -- Refresh the settings menu
        timer.Simple(0.1, function()
            if IsValid(self.Frame) then
                self:Create()
            end
        end)
    end
end

function KEYBIND.Settings:DeleteAllProfiles()
    -- Initialize with default profiles based on rank
    local userGroup = LocalPlayer():GetUserGroup()
    local accessLevel = 0
    
    if userGroup == "loyalty" then
        accessLevel = 2
    elseif userGroup == "premium" then
        accessLevel = 1
    end
    
    local maxProfiles = 3
    if accessLevel == 2 then
        maxProfiles = 7
    elseif accessLevel == 1 then
        maxProfiles = 5
    end
    
    KEYBIND.Storage.Profiles = {}
    
    -- Define base profiles with proper access levels
    local baseProfiles = {
        {name = "Profile1", displayName = "Profile 1", access = 0, color = Color(60, 130, 200)},
        {name = "Profile2", displayName = "Profile 2", access = 0, color = Color(60, 130, 200)},
        {name = "Profile3", displayName = "Profile 3", access = 0, color = Color(60, 130, 200)},
        {name = "Premium1", displayName = "Premium 4", access = 1, color = Color(200, 130, 60)},
        {name = "Premium2", displayName = "Premium 5", access = 1, color = Color(200, 130, 60)},
        {name = "Premium3", displayName = "Loyalty 6", access = 2, color = Color(130, 200, 60)},
        {name = "Premium4", displayName = "Loyalty 7", access = 2, color = Color(130, 200, 60)}
    }
    
    -- Reset only accessible profiles
    for i, profile in ipairs(baseProfiles) do
        local hasAccess = profile.access <= accessLevel and i <= maxProfiles
        
        if hasAccess then
            KEYBIND.Storage.Profiles[profile.name] = {
                binds = {},
                name = profile.name,
                displayName = profile.displayName,
                icon = profile.name -- Set default icon to match profile name
            }
        end
    end
    
    KEYBIND.Storage.CurrentProfile = "Profile1"
    KEYBIND.Storage:SaveBinds()
    
    if KEYBIND.Settings.Config.showFeedback then
        chat.AddText(Color(255, 0, 0), "[BindMenu] Profiles & Binds reset")
    end
    
    -- Refresh menus
    if IsValid(KEYBIND.Menu.Frame) then
        KEYBIND.Menu:RefreshKeyboardLayout()
    end
    self:Create()
end

-- Add a console command to open settings directly
concommand.Add("bindmenu_settings", function()
    KEYBIND.Settings:Create()
end)

KEYBIND = KEYBIND or {}
KEYBIND.Storage = KEYBIND.Storage or {}
KEYBIND.Storage.Profiles = KEYBIND.Storage.Profiles or {}

util.AddNetworkString("KEYBIND_SelectProfile")
util.AddNetworkString("KEYBIND_SelectedProfile")
util.AddNetworkString("KEYBIND_SaveClientProfile")

hook.Add("PlayerInitialSpawn", "KEYBIND_AutoSelectProfile", function(ply)
    local storedProfile = ply:GetInfo("KEYBIND_LastProfile")

    if not KEYBIND.Storage.Profiles["Profile 1"] then
        KEYBIND.Storage.Profiles["Profile 1"] = {
            binds = {},
            settings = {
                showFeedback = true
            }
        }
    end

    if storedProfile and KEYBIND.Storage.Profiles[storedProfile] then
        KEYBIND.Storage.CurrentProfile = storedProfile
    else
        KEYBIND.Storage.CurrentProfile = "Profile 1"
    end

    net.Start("KEYBIND_SelectedProfile")
    net.WriteString(KEYBIND.Storage.CurrentProfile)
    net.Send(ply)
end)

-- First net.Receive handler
net.Receive("KEYBIND_SelectProfile", function(len, ply)
    if not IsValid(ply) then
        print("[KEYBIND] Error: Invalid player in KEYBIND_SelectProfile net message")
        return
    end
    
    local selectedProfile = net.ReadString()
    if selectedProfile and selectedProfile ~= "" then
        -- Don't try to validate against server-side profiles
        -- Just accept any valid profile name from the client
        
        -- Store the current profile for this player
        if not KEYBIND.PlayerProfiles then
            KEYBIND.PlayerProfiles = {}
        end
        KEYBIND.PlayerProfiles[ply:SteamID()] = selectedProfile
        
        -- Run the hook with proper player validation
        hook.Run("KEYBIND_ProfileSelected", ply, selectedProfile)

        -- Send confirmation back to client
        net.Start("KEYBIND_SelectedProfile")
        net.WriteString(selectedProfile)
        net.Send(ply)
        
        print("[KEYBIND] Player " .. ply:Nick() .. " selected profile: " .. selectedProfile)
    else
        print("[KEYBIND] Error: Empty profile name received from player " .. ply:Nick())
    end
end)

-- Function to save player profile
function SavePlayerProfile(ply, profileName)
    if not IsValid(ply) then return end
    
    -- Send the profile name to the client to save in their convar
    net.Start("KEYBIND_SaveClientProfile")
    net.WriteString(profileName)
    net.Send(ply)
    
    -- Store it server-side as well
    if not KEYBIND.PlayerProfiles then
        KEYBIND.PlayerProfiles = {}
    end
    KEYBIND.PlayerProfiles[ply:SteamID()] = profileName
    
    print("[BindMenu] Saved profile " .. profileName .. " for player " .. ply:Nick())
end

hook.Add("KEYBIND_ProfileSelected", "KEYBIND_SaveSelectedProfile", function(ply, profileName)
    if IsValid(ply) then
        SavePlayerProfile(ply, profileName)
    else
        print("[BindMenu] Error: Invalid player in KEYBIND_ProfileSelected hook")
    end
end)

KEYBIND.Layout = KEYBIND.Layout or {}

-- Global settings for keyboard rendering
KEYBIND.Layout.Settings = {
    baseKeySize = 43,
    spacing = 11,
    padding = 35,
    sectionSpacing = 45,
    animationSpeed = 0.2,
    roundness = 6
}

-- Define the complete keyboard layout with improved structure
KEYBIND.Layout.StandardKeyboard = {
    sections = {
        main = {
            id = "main",
            name = "Main Keyboard",
            position = { x = 35, y = 40 },
            rows = {
                {
                    { key = "ESC", width = 1.2 },
                    { key = "", width = 0.5 }, -- Spacer
                    { key = "F1" },
                    { key = "F2" },
                    { key = "F3" },
                    { key = "F4" },
                    { key = "", width = 0.5 }, -- Spacer
                    { key = "F5" },
                    { key = "F6" },
                    { key = "F7" },
                    { key = "F8" },
                    { key = "", width = 0.5 }, -- Spacer
                    { key = "F9" },
                    { key = "F10" },
                    { key = "F11" },
                    { key = "F12" }
                },
                {
                    { key = "`", width = 0.9 },
                    { key = "1", width = 1.1 },
                    { key = "2", width = 1.1 },
                    { key = "3", width = 1.1 },
                    { key = "4", width = 1.1 },
                    { key = "5", width = 1.1 },
                    { key = "6", width = 1.1 },
                    { key = "7", width = 1.1 },
                    { key = "8", width = 1.1 },
                    { key = "9", width = 1.1 },
                    { key = "0", width = 1.1 },
                    { key = "-", width = 0.9 },
                    { key = "=", width = 0.9 },
                    { key = "BACKSPACE", width = 3 }
                },
                {
                    { key = "TAB", width = 1.3 },
                    { key = "Q", width = 1.2 },
                    { key = "W", width = 1.2 },
                    { key = "E", width = 1.2 },
                    { key = "R", width = 1.2 },
                    { key = "T", width = 1.2 },
                    { key = "Y", width = 1.2 },
                    { key = "U", width = 1.2 },
                    { key = "I", width = 1.2 },
                    { key = "O", width = 1.2 },
                    { key = "P", width = 1.2 },
                    { key = "[", width = 1.1 },
                    { key = "]", width = 1.15 },
                    { key = "\\", width = 1.15 }
                },
                {
                    { key = "CAPS", width = 1.75 },
                    { key = "A", width = 1.1 },
                    { key = "S", width = 1.1 },
                    { key = "D", width = 1.1 },
                    { key = "F", width = 1.1 },
                    { key = "G", width = 1.1 },
                    { key = "H", width = 1.1 },
                    { key = "J", width = 1.1 },
                    { key = "K", width = 1.1 },
                    { key = "L", width = 1.1 },
                    { key = ";", width = 1.2 },
                    { key = "'", width = 1.2 },
                    { key = "ENTER", width = 2.9 }
                },
                {
                    { key = "SHIFT", width = 2.25 },
                    { key = "Z", width = 1.3 },
                    { key = "X", width = 1.3 },
                    { key = "C", width = 1.3 },
                    { key = "V", width = 1.3 },
                    { key = "B", width = 1.3 },
                    { key = "N", width = 1.3 },
                    { key = "M", width = 1.3 },
                    { key = ",", width = 1.2 },
                    { key = ".", width = 1.2 },
                    { key = "/", width = 1.2 },
                    { key = "SHIFT", width = 2.25 }
                },
                {
                    { key = "CTRL", width = 1.5 },
                    { key = "WIN", width = 1.25 },
                    { key = "ALT", width = 1.25 },
                    { key = "SPACE", width = 9 },
                    { key = "ALT", width = 1.25 },
                    { key = "WIN", width = 1.25 },
                    { key = "MENU", width = 1.25 },
                    { key = "CTRL", width = 1.45 }
                }
            }
        },
        nav = {
            id = "nav",
            name = "Navigation",
            position = { relativeToSection = "main", offsetX = "end+45", offsetY = 0 },
            rows = {
                {
                    { key = "PRTSC", width = 1.2 },
                    { key = "SCRLK", width = 1.2 },
                    { key = "PAUSE", width = 1.2 }
                },
                {
                    { key = "INS", width = 1.2, prefix = "KP_" },
                    { key = "HOME", width = 1.2, prefix = "KP_" },
                    { key = "PGUP", width = 1.2, prefix = "KP_" }
                },
                {
                    { key = "DEL", width = 1.2, prefix = "KP_" },
                    { key = "END", width = 1.2, prefix = "KP_" },
                    { key = "PGDN", width = 1.2, prefix = "KP_" }
                },
                {
                    { key = "", width = 1 } -- Spacer
                },
                {
                    { key = "", width = 1 },
                    { key = "↑", width = 1.2, prefix = "KP_" },
                    { key = "", width = 1.3 }
                },
                {
                    { key = "←", width = 1.3, prefix = "KP_" },
                    { key = "↓", width = 1.3, prefix = "KP_" },
                    { key = "→", width = 1.3, prefix = "KP_" }
                }
            }
        },
        numpad = {
            id = "numpad",
            name = "Numpad",
            position = { relativeToSection = "nav", offsetX = "end+45", offsetY = 0 },
            rows = {
                {
                    { key = "NMLK", width = 1, prefix = "KP_" },
                    { key = "/", width = 1, prefix = "KP_" },
                    { key = "*", width = 1, prefix = "KP_" },
                    { key = "-", width = 1, prefix = "KP_" }
                },
                {
                    { key = "7", width = 1, prefix = "KP_" },
                    { key = "8", width = 1, prefix = "KP_" },
                    { key = "9", width = 1, prefix = "KP_" },
                    { key = "+", width = 1, height = 2, prefix = "KP_" }
                },
                {
                    { key = "4", width = 1, prefix = "KP_" },
                    { key = "5", width = 1, prefix = "KP_" },
                    { key = "6", width = 1, prefix = "KP_" }
                },
                {
                    { key = "1", width = 1, prefix = "KP_" },
                    { key = "2", width = 1, prefix = "KP_" },
                    { key = "3", width = 1, prefix = "KP_" },
                    { key = "ENTER", width = 1, height = 2, prefix = "KP_" }
                },
                {
                    { key = "0", width = 2.27, prefix = "KP_" },
                    { key = ".", width = 1, prefix = "KP_" }
                }
            }
        }
    }
}
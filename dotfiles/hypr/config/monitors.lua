-- Monitor setup: keep the desktop monitor from the niri config, and let other
-- outputs choose preferred modes automatically.
hl.monitor({ output = "DP-1", mode = "2560x1440@239.970", position = "0x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

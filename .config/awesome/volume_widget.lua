local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

--volume_widget = wibox.widget({ type = "textbox", name = "tb_volume",
--                             align = "right" })

volume_widget = wibox.widget.textbox()
volume_widget.text = "100%"

function update_volume(widget)
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()
    
    local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
    -- volume = string.format("% 3d", volume)

    status = string.match(status, "%[(o[^%]]*)%]")

    -- starting colour
    local sr, sg, sb = 0x3F, 0x3F, 0x3F
    -- ending colour
    local er, eg, eb = 0xDC, 0xDC, 0xCC

    local ir = math.floor(volume * (er - sr) + sr)
    local ig = math.floor(volume * (eg - sg) + sg)
    local ib = math.floor(volume * (eb - sb) + sb)
    interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
    if string.find(status, "on", 1, true) then
        volume = " <span background='#" .. interpol_colour .. "'>   </span>"
    else
        volume = " <span color='red' background='#" .. interpol_colour .. "'> M </span>"
    end
    widget.markup = volume
    end

update_volume(volume_widget)

gears.timer {
    timeout = 1,
    autostart = true,
    callback = function() update_volume(volume_widget) end
}

return volume_widget
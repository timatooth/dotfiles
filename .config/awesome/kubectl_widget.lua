local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

kubectl_widget = wibox.widget.textbox()
kubectl_widget.text = "Loading k8s pods..."

function update_kubectl(widget)
    local command = "echo \"Pods: $(kubectl get pods --all-namespaces | wc -l)\" > /tmp/podcount.txt"

    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell("cat /tmp/podcount.txt", function(out)
            widget.text = out
        end)
    end)
end

update_kubectl(kubectl_widget)

gears.timer {
    timeout = 10,
    autostart = true,
    callback = function() update_kubectl(kubectl_widget) end
}

return kubectl_widget
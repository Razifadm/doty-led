local net = require "luci.model.network"
local sys = require "luci.sys"

local m = Map("netstats", translate("Netstat"),
    translate("Configure traffic monitoring and reset vnStat statistics.")
)

local s = m:section(TypedSection, "config", translate("Settings"))
s.anonymous = true

local backend = s:option(ListValue, "backend", translate("Traffic Backend"))
backend.default = "normal"
backend:value("normal", translate("Normal (Real-time)"))
backend:value("vnstat", translate("vnStat (Historical, Delayed)"))

local mode = s:option(ListValue, "mode", translate("Display Mode"))
mode.default = "daily"
mode:depends("backend", "vnstat")
mode:value("daily", translate("Daily Usage"))
mode:value("monthly", translate("Monthly Usage"))

local iface = s:option(ListValue, "prefer", translate("WAN Interface"))
iface.description = translate(
    "Select the interface for tracking WAN traffic. Leave blank to auto-detect." ..
    "<br><br><b>Backend Mode Explanation:</b><br>" ..
    "<ul>" ..
    "<li><b>vnStat</b>: Uses the vnStat database. It provides daily/monthly usage, but traffic updates are delayed depending on vnStat interval.</li>" ..
    "<li><b>Normal</b>: Reads directly from system interfaces in real time (no delay), but does not keep history.</li>" ..
    "</ul>"
)
iface:value("", translate("Auto detect"))

local netm = net.init()
for _, dev in ipairs(netm:get_interfaces()) do
    local name = dev:shortname()
    if name and not name:match("^lo$") and not name:match("^lan") and not name:match("^br%-") then
        iface:value(name)
    end
end

local function get_vnstat_dbdir()
    local conf = sys.exec("grep -m1 '^DatabaseDir' /etc/vnstat.conf 2>/dev/null")
    local dir = conf:match("DatabaseDir%s+(.+)")
    if dir and #dir > 0 then
        return dir
    end
    return "/etc/vnstat"
end

local reset = s:option(Button, "_reset", translate("Reset All vnStat Stats"))
reset.inputtitle = translate("Reset All Interfaces")
reset.inputstyle = "reset"

function reset.write(self, section)
    local dbdir = get_vnstat_dbdir()
    if not dbdir or dbdir == "" then
        m.errmessage = translate("vnStat database path not found.")
        return
    end

    sys.call("/etc/init.d/vnstat stop")

    local iflist = sys.exec("vnstat --iflist 2>/dev/null")
    local count, success = 0, 0

    for ifc in iflist:gmatch("(%S+)") do
        if ifc ~= "Available" and ifc ~= "interfaces:" then
            count = count + 1
            -- remove DB file
            sys.call("rm -f " .. dbdir .. "/" .. ifc .. " >/dev/null 2>&1")
            local ret = sys.call("vnstat -u -i " .. ifc .. " >/dev/null 2>&1")
            if ret == 0 then
                success = success + 1
            end
        end
    end

    sys.call("/etc/init.d/vnstat start")

    if success == count and count > 0 then
        m.message = translatef("vnStat stats for all %d interfaces have been reset successfully.", count)
        m.errmessage = nil
    elseif count == 0 then
        m.errmessage = translate("No vnStat interfaces found to reset.")
        m.message = nil
    else
        m.errmessage = translatef("Reset attempted on %d interfaces, but only %d succeeded.", count, success)
        m.message = nil
    end
end

return m

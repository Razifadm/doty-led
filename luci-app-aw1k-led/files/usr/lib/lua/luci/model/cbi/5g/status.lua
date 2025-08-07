local sys  = require "luci.sys"
local util = require "luci.util"

local result = sys.exec("/usr/bin/led-status.sh 2>/dev/null")

local m = SimpleForm("led_status", translate("Current LED Status"))
m.description = translate("Live output of current LED behavior from system.")
m.reset = false
m.submit = false

local s = m:section(SimpleSection, nil, translate("This shows the current LED status from the system script."))

local o = s:option(DummyValue, "_status", "")
o.rawhtml = true
o.default = "<pre style='padding: 10px; background: #f9f9f9; border: 1px solid #ccc; border-radius: 5px; white-space:pre-wrap;'>"
    .. util.pcdata(result) .. "</pre>"

return m

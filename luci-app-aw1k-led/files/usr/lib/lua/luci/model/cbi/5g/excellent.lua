m = Map("5g-led", translate(""),
    translate("Configure LED behavior for Excellent 5G signal."))

s = m:section(NamedSection, "excellent", "5g_quality", translate("Excellent Signal Settings"))
s.addremove = false

snr = s:option(Value, "min_snr", translate("Minimum SNR"))
snr.datatype = "uinteger"

color = s:option(ListValue, "color", translate("LED Color"))
color:value("green", "Green")
color:value("blue", "Blue")
color:value("yellow", "Yellow (Red + Green)")
color:value("red", "Red")

blink = s:option(Flag, "blink", translate("Blink LED"))
blink.enabled = "1"
blink.disabled = "0"
blink.default = "0"

return m

m = Map("5g-led", translate("5G LED Settings"))

m.description = translate("Enable or disable individual LED indicators on your 5G modem. Choose 'Enable' or 'Disable' from the dropdown menu for each LED.")

local leds = {
	{ section = "led_power", label = "Power LED" },
	{ section = "led_5g", label = "5G LED" },
	{ section = "led_mobile_signal", label = "Mobile Signal LED" },
	{ section = "led_wifi", label = "Wi-Fi LED" },
	{ section = "led_internate", label = "Internet LED" },
	{ section = "led_phone", label = "Phone LED" }
}

for _, led in ipairs(leds) do
	local s = m:section(TypedSection, led.section, translate(led.label))
	s.anonymous = true
	s.addremove = false

	local o = s:option(ListValue, "enable", translate("Status"))
	o:value("1", translate("Enable"))
	o:value("0", translate("Disable"))
	o.rmempty = false
	o.description = translatef("Enable or disable the %s indicator.", led.label)
end

return m

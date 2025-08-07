-- /usr/lib/lua/luci/model/cbi/5g/settings.lua

m = Map("5g-led", translate("LED Settings"))

-- Tambah keterangan di bawah tajuk utama
m.description = translate("Enable or disable specific LED indicators for different system states.")

s = m:section(NamedSection, "station", "led_control", translate("LED Enable/Disable"))

s:option(Flag, "enable_power", translate("Power LED"))
s:option(Flag, "enable_5g", translate("5G LED"))
s:option(Flag, "enable_mobile_signal", translate("Mobile Signal LED"))
s:option(Flag, "enable_wifi", translate("WiFi LED"))
s:option(Flag, "enable_internet", translate("Internet LED"))
s:option(Flag, "enable_phone", translate("Phone LED"))

return m

local fs = require "nixio.fs"
local sys = require "luci.sys"
local kernel_version = sys.exec("echo -n $(uname -r)")

m = Map("turboacc")
m.title = translate("Turbo ACC Acceleration Settings")
m.description = translate("Support for Nftables-based Flow Offloading and FullCone NAT")

m:append(Template("turboacc/turboacc_status"))

s = m:section(TypedSection, "turboacc", "")
s.addremove = false
s.anonymous = true

if fs.access("/lib/modules/" .. kernel_version .. "/nft_flow_offload.ko") then
	sw_flow = s:option(Flag, "sw_flow", translate("Software flow offloading"))
	sw_flow.default = 0
	sw_flow.description = translate("Software based flow offloading using Nftables")
end

if sys.call("grep -Eq 'filogic|mt762' /etc/openwrt_release") == 0 and
	fs.access("/lib/modules/" .. kernel_version .. "/nft_flow_offload.ko") then
	hw_flow = s:option(Flag, "hw_flow", translate("Hardware flow offloading"))
	hw_flow.default = 0
	hw_flow.description = translate("Requires compatible hardware and nftables flow offload")
	hw_flow:depends("sw_flow", 1)
end

if sys.call("grep -q 'mediatek' /etc/openwrt_release") == 0 and
	fs.access("/lib/modules/" .. kernel_version .. "/mt7915e.ko") then
	hw_wed = s:option(Flag, "hw_wed", translate("MTK WED WO offloading"))
	hw_wed.default = 0
	hw_wed.description = translate("MediaTek Wireless Ethernet Dispatch (WED) acceleration")
	hw_wed:depends("hw_flow", 1)
end

if fs.access("/lib/modules/" .. kernel_version .. "/tcp_bbr.ko") then
	bbr_cca = s:option(Flag, "bbr_cca", translate("BBR CCA"))
	bbr_cca.default = 0
	bbr_cca.description = translate("Enable BBR congestion control algorithm")
end

if fs.access("/lib/modules/" .. kernel_version .. "/nft_fullcone.ko") then
	fullcone_nat = s:option(ListValue, "fullcone_nat", translate("FullCone NAT (nftables)"))
	fullcone_nat.default = 0
	fullcone_nat:value("0", translate("Disable"))
	fullcone_nat:value("1", translate("Compatible Mode"))
	fullcone_nat.description = translate("Using FullCone NAT (via nftables) can improve compatibility and gaming experience")
end

return m

module("luci.controller.nftttl", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/nftttl") then return end
	entry({"admin", "tools", "nftttl"}, cbi("nftttl"), _("TTL Settings"), 60).acl_depends = { "luci-app-nft-ttl" }
end

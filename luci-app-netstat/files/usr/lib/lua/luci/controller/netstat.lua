module("luci.controller.netstat", package.seeall)

function index()
	entry({"admin", "tools", "netstat_config"}, cbi("netstat/config"), _("Netstat Config"), 20).leaf = true
end

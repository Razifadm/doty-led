module("luci.controller.5g_led", package.seeall)

function index()
    entry({"admin", "tools"}, firstchild(), _("Tools"), 50).dependent = false

    entry({"admin", "tools", "5g"}, firstchild(), _("5G LED Config"), 60).dependent = false

    entry({"admin", "tools", "5g", "excellent"}, cbi("5g.excellent"), _("Excellent"), 10).leaf = true
    entry({"admin", "tools", "5g", "good"}, cbi("5g.good"), _("Good"), 20).leaf = true
    entry({"admin", "tools", "5g", "average"}, cbi("5g.average"), _("Average"), 30).leaf = true
    entry({"admin", "tools", "5g", "bad"}, cbi("5g.bad"), _("Bad"), 40).leaf = true
end

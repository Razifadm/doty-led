module("luci.controller.5g_led", package.seeall)

function index()
    if not node("admin", "tools").target then
        entry({"admin", "tools"}, firstchild(), _("Tools"), 50).dependent = false
    end

    entry({"admin", "tools", "5g"}, firstchild(), _("5G LED Config"), 60).dependent = false
    entry({"admin", "tools", "5g", "excellent"}, cbi("5g/excellent"), _("Excellent"), 1)
    entry({"admin", "tools", "5g", "good"}, cbi("5g/good"), _("Good"), 10)
    entry({"admin", "tools", "5g", "average"}, cbi("5g/average"), _("Average"), 20)
    entry({"admin", "tools", "5g", "bad"}, cbi("5g/bad"), _("Bad"), 30)
    entry({"admin", "tools", "5g", "settings"}, cbi("5g/settings"), _("Settings"), 40)
end

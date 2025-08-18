module("luci.controller.toyml", package.seeall)

function index()
    entry({"admin", "tools", "toyml"}, template("toyml"), _("OC Converter"), 90)
    entry({"admin", "tools", "toyml_convert"}, call("convert"), nil).leaf = true
    entry({"admin", "tools", "toyml_save"}, call("save"), nil).leaf = true
end

function convert()
    local fs = require "nixio.fs"
    local sys = require "luci.sys"
    local http = require "luci.http"

    local data = http.formvalue("config") or ""
    if data == "" then
        http.write("")
        return
    end

    fs.writefile("/tmp/toyml_input.txt", data)
    local yaml = sys.exec("/usr/bin/toyml /tmp/toyml_input.txt 2>/dev/null")
    http.write(yaml)
end

function save()
    local fs = require "nixio.fs"
    local http = require "luci.http"

    local filename = http.formvalue("filename") or "custom"
    local yaml = http.formvalue("yaml") or ""

    if filename ~= "" and yaml ~= "" then
        fs.writefile("/etc/openclash/config/" .. filename .. ".yaml", yaml)
        http.write("OK")
    else
        http.write("ERROR")
    end
end


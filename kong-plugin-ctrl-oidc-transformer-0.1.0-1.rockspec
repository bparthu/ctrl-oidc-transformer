package = "kong-plugin-ctrl-oidc-transformer"
version = "0.1.0-1"

-- Extract plugin name from the package name.
local pluginName = package:match("^kong%-plugin%-(.+)$")

supported_platforms = {"linux", "macosx"}
source = {
  url = "https://git.ctrl.nl/core/kong-plugin-ctrl-oidc-transformer.git",
  tag = "0.1.0"
}

description = {
  summary = "Custom plugin to transform headers sent by oidc plugin"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    -- TODO: add any additional files that the plugin consists of
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
    ["kong.plugins."..pluginName..".access"] = "kong/plugins/"..pluginName.."/access.lua",
  }
}

package = "ctrl-oidc-transformer"
version = "0.1.0-1"

-- Extract plugin name from the package name.
local pluginName = package:match("^kong%-plugin%-(.+)$")

supported_platforms = {"linux", "macosx"}
source = {
  url = "https://git.ctrl.nl/core/ctrl-oidc-transformer.git"
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
    ["kong.plugins.ctrl-oidc-transformer.handler"] = "kong/plugins/ctrl-oidc-transformer/handler.lua",
    ["kong.plugins.ctrl-oidc-transformer.schema"] = "kong/plugins/ctrl-oidc-transformer/schema.lua",
    ["kong.plugins.ctrl-oidc-transformer.access"] = "kong/plugins/ctrl-oidc-transformer/access.lua",
  }
}

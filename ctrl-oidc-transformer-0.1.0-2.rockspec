package = "ctrl-oidc-transformer"
version = "0.1.0-2"

source = {
    url = "git://github.com/bparthu/ctrl-oidc-transformer"
}

description = {
  summary = "Custom plugin to transform headers sent by oidc plugin"
}

dependencies = {
  "lua >= 5.1"
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

local lu = require("luaunit")
TestHandler = require("test.unit.mockable_case"):extend()

function TestHandler:setUp()
  TestHandler.super:setUp()
  self.logged = false;
  ngx.log = function(...)
    self.logged = true
  end
  self.cjson = package.loaded.cjson
  package.loaded.cjson = nil
  package.preload["cjson"] = function()
    return {
      encode = function(...) return "encoded" end,
      decode = function(...)
        -- something really bad happens
        return 5 / nil
      end
    }
  end
  self.handler = require("kong.plugins.ctrl-oidc-transformer.handler")
end

function TestHandler:tearDown()
  TestHandler.super:tearDown()
  self.logged = false;
end

function TestHandler:test_sad_path_wrong_input_value_in_header()
  local config = {
    input_header_name = "x-userinfo",
    is_input_header_base64 = false,
    output_header_prefix = "x-ctrl-"
  }
  local headers = {}
  headers["x-userinfo"] = "nonsense_data_here"
  ngx.req.get_headers = function()
    return headers
  end
  ngx.req.set_header = function(h, v)
    headers[h] = v
  end

  self.handler:access(config)
  lu.assertTrue(self.logged)
end

function TestHandler:test_sad_path_wrong_invalid_header_config()
  local config = {
    input_header_name = "invalid-input-header",
    is_input_header_base64 = false,
    output_header_prefix = "x-ctrl-"
  }
  local headers = {}
  headers["x-userinfo"] = "nonsense_data_here"
  ngx.req.get_headers = function()
    return headers
  end
  ngx.req.set_header = function(h, v)
    headers[h] = v
  end

  self.handler:access(config)
  lu.assertTrue(self.logged)
end

lu.run()

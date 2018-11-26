local lu = require("luaunit")
TestHandler = require("test.unit.mockable_case"):extend()

function TestHandler:setUp()
  TestHandler.super:setUp()
  ngx.log = function(...) end
  self.cjson = package.loaded.cjson
  package.loaded.cjson = nil
  package.preload["cjson"] = function()
    return {
      encode = function(...) return "encoded" end,
      decode = function(...) return {id = "3802297f-e6ed-47c7-a351-b7a6f6ea858f",email_verified = false,sub = "3802297f-e6ed-47c7-a351-b7a6f6ea858f",username = "kvanduijn",preferred_username = "kvanduijn"} end
    }
  end
  self.handler = require("kong.plugins.ctrl-oidc-transformer.handler")
end

function TestHandler:tearDown()
  TestHandler.super:tearDown()
end

function TestHandler:test_happy_path_WITH_base64_encoded_input_header()
  local config = {
    input_header_name = "x-userinfo",
    is_input_header_base64 = true,
    output_header_prefix = "x-ctrl-"
  }
  local headers = {}
  headers["x-userinfo"] = "eyJpZCI6IjM4MDIyOTdmLWU2ZWQtNDdjNy1hMzUxLWI3YTZmNmVhODU4ZiIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwic3ViIjoiMzgwMjI5N2YtZTZlZC00N2M3LWEzNTEtYjdhNmY2ZWE4NThmIiwidXNlcm5hbWUiOiJrdmFuZHVpam4iLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJrdmFuZHVpam4ifQ=="
  ngx.req.get_headers = function()
    return headers
  end
  ngx.req.set_header = function(h, v)
    headers[h] = v
  end
  ngx.decode_base64 = function()
    return "{\"id\":\"3802297f-e6ed-47c7-a351-b7a6f6ea858f\",\"email_verified\":false,\"sub\":\"3802297f-e6ed-47c7-a351-b7a6f6ea858f\",\"username\":\"kvanduijn\",\"preferred_username\":\"kvanduijn\"}"
  end

  self.handler:access(config)
  lu.assertEquals(headers['x-ctrl-id'], "3802297f-e6ed-47c7-a351-b7a6f6ea858f")
  lu.assertEquals(headers['x-ctrl-email_verified'], false)
  lu.assertEquals(headers['x-ctrl-sub'], "3802297f-e6ed-47c7-a351-b7a6f6ea858f")
  lu.assertEquals(headers['x-ctrl-username'], "kvanduijn")
  lu.assertEquals(headers['x-ctrl-preferred_username'], "kvanduijn")
end

function TestHandler:test_happy_path_WITHOUT_base64_encoded_input_header()
  local config = {
    input_header_name = "x-userinfo",
    is_input_header_base64 = true,
    output_header_prefix = "x-ctrl-"
  }
  local headers = {}
  headers["x-userinfo"] = "eyJpZCI6IjM4MDIyOTdmLWU2ZWQtNDdjNy1hMzUxLWI3YTZmNmVhODU4ZiIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwic3ViIjoiMzgwMjI5N2YtZTZlZC00N2M3LWEzNTEtYjdhNmY2ZWE4NThmIiwidXNlcm5hbWUiOiJrdmFuZHVpam4iLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJrdmFuZHVpam4ifQ=="
  ngx.req.get_headers = function()
    return headers
  end
  ngx.req.set_header = function(h, v)
    headers[h] = v
  end
  ngx.decode_base64 = function()
    return "{\"id\":\"3802297f-e6ed-47c7-a351-b7a6f6ea858f\",\"email_verified\":false,\"sub\":\"3802297f-e6ed-47c7-a351-b7a6f6ea858f\",\"username\":\"kvanduijn\",\"preferred_username\":\"kvanduijn\"}"
  end

  self.handler:access(config)
  lu.assertEquals(headers['x-ctrl-id'], "3802297f-e6ed-47c7-a351-b7a6f6ea858f")
  lu.assertEquals(headers['x-ctrl-email_verified'], false)
  lu.assertEquals(headers['x-ctrl-sub'], "3802297f-e6ed-47c7-a351-b7a6f6ea858f")
  lu.assertEquals(headers['x-ctrl-username'], "kvanduijn")
  lu.assertEquals(headers['x-ctrl-preferred_username'], "kvanduijn")
end

lu.run()

local _M = {}
local cjson = require("cjson")


function _M.execute(conf)
  local ngx_set_header = ngx.req.set_header
  local req_get_headers = ngx.req.get_headers
  if ngx.req.get_headers()[conf.input_header_name] then
    ngx.log(ngx.NOTICE, "found "..conf.input_header_name.." header and transforming...")
    local decoded_text
    if conf.is_input_header_base64 then 
      decoded_text = ngx.decode_base64(req_get_headers()[conf.input_header_name])
    else
      decoded_text = req_get_headers()[conf.input_header_name]
    end
    local status, ret, err = xpcall (cjson.decode, debug.traceback, decoded_text)
    if status then
      for k,v in pairs(ret) do
        ngx_set_header(conf.output_header_prefix..k, v)
      end
    else
      ngx.log(ngx.ERR, "Unable to parse object from header -> "..conf.input_header_name)
      ngx.log(ngx.ERR, ret)
    end
  else
    ngx.log(ngx.ERR, conf.input_header_name.." header unavaiable")
  end
end



return _M
local _M = {}
local ngx_set_header = ngx.req.set_header
local req_get_headers = ngx.req.get_headers


function _M.execute(conf)
  
  if req_get_headers()[conf.input_header_name] then
    ngx.log(ngx.INFO, "found "..conf.input_header_name.." header and transforming...")
    local value = req_get_headers()[conf.input_header_name]
    ngx_set_header(conf.output_header_name, value)
  else
    ngx.log(ngx.ERR, conf.input_header_name.." header unavaiable")
  end

end



return _M
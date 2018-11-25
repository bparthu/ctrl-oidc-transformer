local _M = {}
local ngx_set_header = ngx.req.set_header
local req_get_headers = ngx.req.get_headers


function _M.execute(conf)

  if conf.say_hello then
    ngx.log(ngx.ERR, "============ Hello World! ============")
    if req_get_headers()["x-ctrl-username"] then
      ngx.log(ngx.ERR, "found x-ctrl-username header")
      local value = req_get_headers()["x-ctrl-username"]
      ngx_set_header("x-new-header", value)
    end
    ngx_set_header("hello-world","Hello World !!!")
  else

    ngx.log(ngx.ERR, "============ Bye World! ============")
    ngx_set_header("hello-world","bye World !!!")

  end

end



return _M
local utils = require 'utils'

utils:count(ngx.var.tenant, ngx.var.day, ngx.var.key, ngx.var.arg_v)
utils:exit()

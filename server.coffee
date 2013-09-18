connect = require "connect"
path = require "path"

# simple webserver
# usage:
# ------
#   node server.js 

if process.env.PORT
  port = process.env.PORT
else
  port = 8080

unless webroot
  webroot = './build/'

connect()
  .use(connect.static(webroot))
  .use(connect.logger('dev'))
  .listen(port)
console.log "server started on port: #{port}, path: '#{webroot}'"
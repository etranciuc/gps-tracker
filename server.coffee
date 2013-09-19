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
  webroot = './www/'

server = connect()
  .use(connect.logger('dev'))
  .use(connect.static(webroot))
  .listen(port)
console.log "server started on port: #{port}, path: '#{webroot}'"
connect = require "connect"
express = require "express"
path = require "path"

# callback doesn't take any parameters and (if provided) should be called after server is started
# should return an instance of http.Server
exports.startServer = (port, path, callback) ->
  app = express()

  if process.env.PORT
    port = process.env.PORT
    
  app.listen port
  console.log "server started on port: #{port}, path: #{path}"

  app.use connect.logger('dev')
  # static files
  app.use express.static "#{path}"
  return app
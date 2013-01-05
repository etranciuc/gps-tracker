connect = require "connect"
express = require "express"
path = require "path"
qs = require "qs"
xml2js = require "xml2js"
http = require "http-get"

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
  # stations api
  app.get '/stations*', (request, response) ->
    query =
      petrol_type_master_id: request.query.petrol_type
      gas_station_distance: request.query.distance
      lat: request.query.lat
      lng: request.query.lng
    url = "http://www.tankcheck.de/js/get_gas_station.php?" + qs.stringify(query)
    # load xml from remote server
    options = 
      url: url
      bufferType: 'buffer'
    console.log url
    http.get options, (error, result) ->
      if error
        console.error error
        response.send error
        return
      else
        # convert to json and output
        parser = new xml2js.Parser()
        parser.parseString(""+result.buffer, (error, result) ->
          if error
            response.send error
            console.error error
          # conversion from their names and types to our types and names
          translationTable =
             ID: 'id'
             Count: 'count'
             Station_Name: 'name'
             Station_Address: 'address'
             Station_City: 'city'
             Station_Zip_Code: 'zip'
             Distance: 'distance'
             Price: 'price'
             Created: 'created'
             latitude: 'latitude'
             longitude: 'longitude'
          stations = []
          for index, record of result.REQUEST.Gas_Station
            station = {}
            for attributeName, attributeValue of record
              if translationTable[attributeName]?
                station[translationTable[attributeName]] = attributeValue[0]
            if station.id?
              station.id = parseInt(station.id)
            if station.count?
              station.count = parseInt(station.count)
            if station.distance?
              station.distance = parseFloat(station.distance)
            if station.price?
              station.price = parseFloat(station.price)
            if station.latitude?
              station.latitude = parseFloat(station.latitude)
            if station.longitude?
              station.longitude = parseFloat(station.longitude)
            stations.push station
          response.send(stations)
        )
  return app
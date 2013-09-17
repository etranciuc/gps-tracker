define [
  'models/base/collection'
  'models/geolocation'
], (Collection, Geolocation) ->

  class Route extends Collection

    model: Geolocation
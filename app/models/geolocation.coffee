define [
  'models/base/model'
], (Model) ->
  'use strict'

  class Geolocation extends Model

    # http://dev.w3.org/geo/api/spec-source.html
    options: 
      timeout: 30 * 1000
      maximumAge: 5 * 1000
      enableHighAccuracy: true
      frequency: 5000

    defaults:
      longitude: null
      latitude: null
      accuracy: false
      altitude: false
      heading: false
      speed: false
      lastUpdate: false

    watchId: null

    pollIntervalId: null

    setters:
      accuracy: (value) ->
        if value >= 0
          return value
        return false
      heading: (value) ->
        if 0 <= value <= 360
          return value
        return false
      speed: (value) ->
        if value >= 0
          return value
        return false
      # transform position timestamp to real Date instance  
      # if timestamp was not set, use current client’s time
      lastUpdate: (value) ->
        # on android systems timestamp is a Date object allready
        if typeof value is 'object'
          return value
        # on other clients timestamp is a actual timestamp (seconds)
        timestampString = new String value
        # chrome seemes to be the only browser which posts the location
        # timestamp in seconds, all other browsers post epoch milliseconds
        # that’s why we have to convert milliseconds to seconds
        if timestampString.length is 16
          date = new Date()
          date.setTime(value / 1000)
          return date
        return new Date(value)

    getters:
      latLng: ->
        return new google.maps.LatLng @get('latitude'), @get('longitude')

    # updates the geoposition by random values every interval milliseconds
    startRandomUpdates: (delay = 1000, longitude = 13.4529, latitude = 52.5092) => 
      # method that randomly updates geolocation
      randomUpdate = =>
        @set
          longitude: longitude + (1 - Math.random() * 2) * Math.random() * 0.025
          latitude: latitude + (1 - Math.random() * 2) * Math.random() * 0.025
          accuracy: 10 + Math.random() * 20
      # create interval
      @randomUpdateInterval = window.setInterval randomUpdate, delay

    # stops random updates
    stopRandomUpdates: =>
      if @randomUpdateInterval
        window.clearInterval @randomUpdateInterval
      @

    startWatchPosition: =>
      unless navigator.geolocation?
        throw new Error """
        Unable to find navigator.geolocation support in the current client
        """
      else
        navigator.geolocation.getCurrentPosition @onPositionUpdate, @onError, @options
        @watchPosition()
      @
         
    pollCurrentPosition: =>
      if @pollIntervalId
        window.clearInterval(@pollIntervalId)
      callback = =>
        navigator.geolocation.getCurrentPosition @onPositionUpdate, @onError, @options
      @pollIntervalId = window.setInterval callback, @options.frequency

    watchPosition: =>
      @watchId = navigator.geolocation.watchPosition @onPositionUpdate

    onPositionUpdate: (position) =>
      
      unless position.coords
        @onError "Position update with invalid position hash. (position.coords expected)"
        return

      if position.timestamp?
        @set 'lastUpdate', position.timestamp
      else
        lastUpdate = new Date()
        @set 'lastUpdate', new Date()
      
      @set position.coords

      console.debug 'onPositionUpdate %s', @toString()

      # android devices need to get getCurrentPosition called in a defined interval
      # because watchPosition does not work
      isAndroid = navigator.userAgent.toLowerCase().indexOf('android') > -1
      if isAndroid
        @pollCurrentPosition()

    onError: (error) =>
      @trigger 'error', @, error
      console.error error

    toString: ->
      unless @get('longitude')? and @get('latitude')?
        return "unknown"
      string = @get('longitude') + '/' +  @get('latitude')
      if @get('accuracy')
        string += " (" + @get('accuracy')+ "m)"
      return string
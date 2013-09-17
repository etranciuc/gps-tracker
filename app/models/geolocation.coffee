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

    getters:
      latLng: ->
        return new google.maps.LatLng @get('latitude'), @get('longitude')

    initialize: ->
      super
      unless navigator.geolocation
        throw new Error """
        Unable to find navigator.geolocation support in the current client
        """
      else
        # navigator.geolocation.getCurrentPosition @onPositionUpdate, @onError, @options
        # @watchPosition()
         
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

      # transform position timestamp to real Date instance  
      # if timestamp was not set, use current client’s time
      unless position.timestamp?
        lastUpdate = new Date()
      # on android systems timestamp is a Date object allready
      else if typeof position.timestamp is 'object'
        lastUpdate = position.timestamp
      # on other systems timestamp might be timestamp
      else
          timestampString = new String position.timestamp
          # chrome contains timestamp in seconds and all other browsers in
          # seconds so we need to calculate a bit here
          lastUpdate = new Date(position.timestamp)
          if timestampString.length is 16
            lastUpdate.setTime(position.timestamp / 1000)

      @set 'lastUpdate', lastUpdate
      # update model with data from position.coords
      @set position.coords

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
Model = require 'models/base/model'

module.exports = class Geolocation extends Model

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
     lastUpdate: false

  watchId: null

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
      @pollCurrentPosition()
      @watchPosition()  
       
  pollCurrentPosition: =>
    navigator.geolocation.getCurrentPosition @onPositionUpdate, @onError, @options

  watchPosition: =>
    @watchId = navigator.geolocation.watchPosition @onPositionUpdate

  onPositionUpdate: (position) =>
    
    # android devices need to get getCurrentPosition called in a defined interval
    # because watchPosition does not work
    isAndroid = navigator.userAgent.toLowerCase().indexOf('android') > -1
    if isAndroid
      window.setTimeout @pollCurrentPosition, @options.frequency

    unless position.coords
      @onError "Position update with invalid position hash. (position.coords expected)"
      return

    # transform position timestamp to real Date instance  
    if position.timestamp?
      timestampString = new String position.timestamp
      # chrome contains timestamp in seconds and all other browsers in
      # seconds so we need to calculate a bit here
      date = new Date(position.timestamp)
      if timestampString.length is 16
        date.setTime(position.timestamp / 1000)
      @set 'lastUpdate', date
    else
      @set 'lastUpdate', new Date()

    # update model with data from position.coords
    @set position.coords

  onError: (error) =>
    @trigger 'error', @, error
    console.error error

  toString: ->
    unless @get('longitude') and @get('latitude')
      return "unknown"
    string = @get('longitude') + ', ' +  @get('latitude')
    if @get('accuracy')
      string += " (" + @get('accuracy')+ ")"
    return string
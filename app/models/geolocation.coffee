Model = require 'models/base/model'

module.exports = class Geolocation extends Model

  options: 
    timeout: 5 * 1000
    maximumAge: 1000 * 60 * 15
    enableHighAccuracy: true
    frequency: 5000
    maximumAge: 5000

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
      navigator.geolocation.getCurrentPosition @onPositionUpdate, @onError, @options
      @watchId = navigator.geolocation.watchPosition @onPositionUpdate

  onPositionUpdate: (position) =>
    unless position.coords
      throw new Error """
      Position update with invalid position hash. (position.coords expected)
      """
    if position.timestamp
      timestampString = new String position.timestamp
      # chrome contains timestamp in seconds and all other browsers in
      # seconds so we need to calculate a bit here
      date = new Date(position.timestamp)
      if timestampString.length is 16
        date.setTime(position.timestamp / 1000)
      @set 'lastUpdate', date
    else
      @set 'lastUpdate', new Date()
    @set position.coords

  onError: (error) =>
    trigger 'error', @, error
    console.error error
    alert error

  toString: ->
    unless @get('longitude') and @get('latitude')
      return "unknown"
    string = @get('longitude') + ', ' +  @get('latitude')
    if @get('accuracy')
      string += " (" + @get('accuracy')+ ")"
    return string
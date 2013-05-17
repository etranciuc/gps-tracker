MarkerView = require 'views/base/marker_view'

module.exports = class GeolocationMarkerView extends MarkerView

  options:
    fillColor: '#4579fd'
    fillOpacity: 0.125
    strokeColor: '#2d4fd1'
    strokeOpacity: 1
    strokeWeight: 1
    clickable: false

  circle: null

  initialize: ->
    super
    @modelBind 'change:accuracy', @onAccuracyChange

  render: ->
    super
    # replace icon
    imageSize = 24
    image = new google.maps.MarkerImage 'images/poi.png',
      new google.maps.Size(imageSize, imageSize),
      new google.maps.Point(0,0),
      new google.maps.Point(imageSize / 4, imageSize / 4)
      new google.maps.Size(imageSize / 2, imageSize / 2),
    @marker.setIcon(image)
    # create circle for accuracy
    options = _(@options).extend
      map: @options.map
      center: @marker.getPosition()
    @circle = new google.maps.Circle options
    @

  reCenter: ->
    @options.map.setCenter @marker.getPosition()

  onPositionChange: (geolocation) =>
    super
    # set circle to new position
    @circle.setCenter @marker.getPosition()
    # # re-set center of the map to my position
    @reCenter()
    @

  onAccuracyChange: (geolocation) =>
    accuracy = geolocation.get 'accuracy'
    radius =
      if accuracy is false
        50
      else if accuracy > 5
        accuracy
      else
        0
    @circle.setRadius radius
    @
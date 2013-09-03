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
    imageSize = 24 # width/height of the poi marker
    imageScale = 0.5 # scale the image (retina-ready)
    image = new google.maps.MarkerImage 'images/poi.png',
      new google.maps.Size(imageSize, imageSize),
      new google.maps.Point(0, 0),
      new google.maps.Point(imageSize / 2 * imageScale, imageSize / 2 * imageScale)
      new google.maps.Size(imageSize * imageScale, imageSize * imageScale),
    @marker.setIcon(image)
    # create circle for accuracy
    options = _(@options).extend
      map: @options.map
      center: @marker.getPosition()
    @circle = new google.maps.Circle options
    @

  onPositionChange: (geolocation) =>
    super
    @circle.setCenter @marker.getPosition()
    @

  onAccuracyChange: (geolocation) =>
    accuracy = geolocation.get 'accuracy'
    # only draw radius of accuracy if it’s beyond 5m
    radius =
      if accuracy is false
        50
      else if accuracy > 5
        accuracy
      else
        0
    @circle.setRadius radius
    @
define [
  'views/base/marker_view'
], (MarkerView) ->
  
  class GeolocationMarkerView extends MarkerView

    options:
      fillColor: '#4579fd'
      fillOpacity: 0.125
      strokeWeight: 0
      clickable: false

    circle: null

    render: ->
      super
      
      # replace icon
      imageSize = 32
      image = new google.maps.MarkerImage 'images/poi.png',
        new google.maps.Size(imageSize, imageSize),
        new google.maps.Point(0,0),
        new google.maps.Point(imageSize / 4, imageSize / 4)
        new google.maps.Size(imageSize / 2, imageSize / 2),
      @marker.setIcon image

      # create circle for accuracy
      options = _(@options).extend
        center: @marker.getPosition()
      @circle = new google.maps.Circle options

      @

    onPositionChange: (geolocation) =>
      super
      @circle.setCenter @marker.getPosition()
      @circle.setRadius geolocation.get 'accuracy'
      @
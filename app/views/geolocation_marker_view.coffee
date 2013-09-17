define [
  'views/base/marker_view'
], (MarkerView) ->
  
  class GeolocationMarkerView extends MarkerView

    options:
      fillColor: '#4579fd'
      fillOpacity: 0.125
      strokeColor: '#2d4fd1'
      strokeOpacity: 1
      strokeWeight: 1
      clickable: false

    circle: null

    listen:
      'change:accuracy model': 'onAccuracyChange'

    render: ->
      super
      
      # replace icon
      imageSize = 24
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
      window.setInterval @renderPulse, 25
      @

    renderPulse: =>
      unless @pulseRadius?
        @pulseRadius = 5
      else
        @pulseRadius = @pulseRadius + 1
      if @pulseRadius > 50
        @pulseRadius = 1
      @circle.setOptions
        fillOpacity: @pulseRadius/100 * 0.5
      @circle.setRadius @pulseRadius

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
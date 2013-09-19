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

    renderPulseInterval: null

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

      # create interval for pulsing radius
      @renderPulseInterval = window.setInterval @renderPulse, 25
      @

    dispose: =>
      super
      window.clearInterval @renderPulseInterval

    onPositionChange: (geolocation) =>
      super
      @circle.setCenter @marker.getPosition()
      @

    renderPulse: =>
      unless @model.get 'accuracy'
        return
      # calculate current state of pulse radius
      unless @pulseRadius?
        @pulseRadius = @model.get('accuracy')
      else
        @pulseRadius = @pulseRadius + 1

      # draw radius should not extend current accuracy
      if @pulseRadius > @model.get('accuracy')
        @pulseRadius = 1

      @circle.setRadius @pulseRadius
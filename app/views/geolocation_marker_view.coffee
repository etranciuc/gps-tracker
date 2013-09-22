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

      # create interval for pulsing radius
      @renderPulse()
      @

    dispose: =>
      super
      if @renderPulseInterval
        window.clearInterval @renderPulseInterval

    onPositionChange: (geolocation) =>
      super
      @circle.setCenter @marker.getPosition()
      @

    setRadius: (radius) =>
      @circle.setRadius radius

    # 0 - 100
    step: 0
    renderPulse: =>

      toValue = @model.get 'accuracy' # value when step = 100
      duration = 0.5 # animation duration in seconds
      delay = duration / toValue
      radius = @step / 100 * toValue

      if @step > 100
        @step = 0
      else
        @step++;

      @setRadius radius

      # repeat till the end of time or @dispose is called
      @renderPulseInterval = window.setTimeout @renderPulse, delay
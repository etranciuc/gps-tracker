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

      @

    dispose: =>
      super
      if @renderPulseInterval
        window.clearInterval @renderPulseInterval

    onPositionChange: (geolocation) =>
      super
      @circle.setCenter @marker.getPosition()
      @renderPulse()
      @

    setRadius: (radius) =>
      @circle.setRadius radius

    # 0 - 1
    step: 0

    renderPulse: =>
      # animation inputs
      value = @model.get 'accuracy' # value when step = 100
      duration = 5.00 # animation duration in seconds

      # calculate delay between animation steps
      delay = duration / value * 10000
      # calculation of current state (and values) of the animation
      radius = value * @step

      # set the radius
      @setRadius radius

      # repeat till the end of time or @dispose is called
      @renderPulseInterval = window.setTimeout @renderPulse, delay

      # make sure steps are limited between 0..1 as this is our timebase
      if @step > 1
        @step = 0
        console.log ' STEP SIZED'
        window.clearInterval @renderPulse
      else
        @step += delay
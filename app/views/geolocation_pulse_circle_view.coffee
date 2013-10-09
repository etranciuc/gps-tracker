define [
  'views/base/view'
], (View) ->

  # @TODO refactor together with accuracycircleview to OverlayMapView class or
  # something else
  class GeolocationPulseCircleView extends View

    autoRender: yes

    options:
      fillColor: '#4579fd'
      fillOpacity: 0.25
      strokeWeight: 0
      clickable: false

    circle: null
    interval: null
    step: 0.0

    listen:
      'change:longitude model': 'onPositionChange'
      'change:latitude model': 'onPositionChange'

    dispose: ->
      if @circle?
        @circle.setMap null
      if @interval?
        window.clearInterval @interval
      super

    render: ->
      super
      options = _(@options).extend
        center: @model.get 'latLng'
        map: @options.map
      @circle = new google.maps.Circle options
      @animatePulse()
      @

    animatePulse: =>
      a = 0 # start value
      b = @model.get 'accuracy' # end value
      d = 1750 # duration of animation in milliseconds
      s = 50 # step refresh interval size in milliseconds

      @step += s / d
      if @step > 1
        @step = 0
      @interval = window.setTimeout @animatePulse, s

      # radius easing
      radius = a + Math.pow(@step, 0.5) * (b - a)
      @circle.setRadius radius

      # opacity effect
      opacityStart = @options.fillOpacity
      opacityEnd = 0
      opacity = opacityStart + @step * (opacityEnd - opacityStart)

      @circle.setOptions
        fillOpacity: opacity


    onPositionChange: (geolocation) =>
      @circle.setCenter geolocation.get 'latLng'
      @
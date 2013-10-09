define [
  'views/base/view'
], (View) ->

  class GeolocationAccuracyCircleView extends View

    autoRender: yes

    options:
      fillColor: '#4579fd'
      fillOpacity: 0.125
      strokeWeight: 0
      clickable: false

    circle: null

    listen:
      'change:longitude model': 'onPositionChange'
      'change:latitude model': 'onPositionChange'
      'change:accuracy model': 'onAccuracyChange'

    dispose: ->
      if @circle?
        @circle.setMap null
      super

    render: ->
      super

      # create circle for accuracy
      options = _(@options).extend
        center: @model.get 'latLng'
        map: @options.map
      @circle = new google.maps.Circle options

      @

    onPositionChange: (geolocation) =>
      @circle.setCenter geolocation.get 'latLng'
      @

    onAccuracyChange: (geolocation) =>
      @circle.setRadius geolocation.get 'accuracy'
      @
define [
  'views/base/view'
], (View) ->
  'use strict'

  class MapView extends View

    id: 'map'

    autoRender: yes

    options:
      zoom: 17
      streetViewControl: no

    map: null

    position: (x, y) ->
      console.debug 'MapView.position', arguments
      @$el.css
        'margin-left': x
        'margin-top': y
      @

    setCenter: (getPosition) ->
      @map.setCenter getPosition.get('latLng')
      @

    resize: (width, height) ->
      console.debug 'MapView.resize', arguments
      @$el.css
        height: height
        widht: width
      google.maps.event.trigger @map, 'resize'
      @
      
    render: ->
      super
      @map = new google.maps.Map @$el[0], @options
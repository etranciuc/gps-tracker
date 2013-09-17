define [
  'views/base/view'
], (View) ->
  'use strict'

  class MapView extends View

    id: 'map'

    autoRender: yes

    options:
      zoom: 17

    map: null

    position: (x, y) ->
      console.info 'MapView.position', arguments
      @$el.css
        'margin-left': x
        'margin-top': y
      @

    setCenter: (getPosition) ->
      console.info 'MapView.position', arguments
      @map.setCenter getPosition.get('latLng')
      @

    resize: (width, height) ->
      console.info 'MapView.resize', arguments
      @$el.css
        height: height
        widht: width
      google.maps.event.trigger @map, 'resize'
      @
      
    render: ->
      super
      @map = new google.maps.Map @$el[0], @options
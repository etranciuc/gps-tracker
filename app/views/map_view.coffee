define [
  'views/base/view'
], (View) ->
  'use strict'

  class MapView extends View

    id: 'map'

    autoRender: yes

    options:
      zoom: 17
      # mapTypeId: google.maps.MapTypeId.ROADMAP

    map: null

    position: (x, y) ->
      @$el.css
        'margin-left': x
        'margin-top': y
      @

    setCenter: (getPosition) ->
      @map.setCenter getPosition.get('latLng')
      @

    resize: (width, height) ->
      @$el.css
        height: height
        widht: width
      google.maps.event.trigger @map, 'resize'
      @trigger 'resize', @, width, height
      @
      
    render: ->
      super
      @map = new google.maps.Map @$el[0], @options
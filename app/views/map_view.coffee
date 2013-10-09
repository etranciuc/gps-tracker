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

    # list of themes for google maps
    themes:
      default: []
      night: [
        stylers: [
          invert_lightness: yes
        ]
      ]

    listen:
      'application:config:change:theme mediator': 'useTheme'

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

    useTheme: (theme) =>
      # check if theme is defined
      unless @themes[theme]
        throw new Error """
        unable to find theme #{theme} definition in MapView class
        """
      # apply theme
      @map.setOptions
        styles: @themes[theme]
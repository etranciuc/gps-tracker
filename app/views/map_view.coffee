View = require 'views/base/view'

module.exports = class MapView extends View

  id: 'map'

  autoRender: yes

  options:
    zoom: 17
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map: null

  position: (x, y) ->
    @$el.css
      'margin-left': x
      'margin-top': y
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
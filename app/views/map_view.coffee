View = require 'views/base/view'

module.exports = class MapView extends View

  id: 'map'

  autoRender: yes

  options:
    zoom: 18
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map: null

  resize: (width, height) ->
    @$el.css
      height: width
      widht: height
    google.maps.event.trigger @map, 'resize'
    @trigger 'resize', @, width, height
    @
    
  render: ->
    super
    @map = new google.maps.Map @$el[0], @options
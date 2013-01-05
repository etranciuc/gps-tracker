View = require 'views/base/view'

module.exports = class MapView extends View

  id: 'map'

  autoRender: yes

  options:
    zoom: 18
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map: null
    
  render: ->
    super
    @map = new google.maps.Map @$el[0], @options
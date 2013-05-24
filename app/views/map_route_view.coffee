View = require 'views/base/view'
Route = require 'models/route'

module.exports = class MapRouteView extends View

  autoRender: yes

  marker: null

  options: 
    strokeColor: '#0080ff'
    strokeOpacity: 0.5
    strokeWeight: 10

  initialize: ->
    super
    @route = new Route
    @modelBind 'change:longitude change:latitude', @onPositionChange

  onPositionChange: (geolocation) =>
    @route.add geolocation.toJSON()
    @render()

  render: =>
    if @route.length < 2
      return
    coords = @route.pluck('latLng');
    
    route = new google.maps.Polyline(
      _(path: coords).extend @options
    )

    route.setMap(@options.map)

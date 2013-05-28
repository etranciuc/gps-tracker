View = require 'views/base/view'
Route = require 'models/route'

module.exports = class MapRouteView extends View

  autoRender: no

  marker: null

  options: 
    strokeColor: '#0080ff'
    strokeOpacity: 0.5
    strokeWeight: 10

  # Stores the route which is rendered on the mao
  # TODO: optimizations needed
  route: null

  # stores an instance of the polyline which is rendered on the map
  polyline: null

  initialize: ->
    super
    @route = new Route
    @modelBind 'change:longitude change:latitude', @onPositionChange
    @route.on 'add', @render, @

  onPositionChange: (geolocation) =>
    @route.add geolocation.toJSON()
    @

  dispose: =>
    if @polyline
      @polyline.setMap(null)
    super

  render: =>
    # create polyline if not allready there
    unless @polyline
      @polyline = new google.maps.Polyline @options

    # do not render any routes which have less than 2 points
    if @route.length < 1
      return

    path = @polyline.getPath()
    path.push @route.last().get 'latLng'
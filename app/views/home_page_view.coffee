template = require 'views/templates/home'
PageView = require 'views/base/page_view'
MapView = require 'views/map_view'
Geolocation = require 'models/geolocation'
GeolocationMarkerView = require 'views/geolocation_marker_view'
GeolocationInfoView = require 'views/geolocation_info_view'
MapRouteView = require 'views/map_route_view'
ConfigView = require 'views/config_view'
Config = require 'models/config'

module.exports = class HomePageView extends PageView

  id: 'home-page-view'

  template: template

  initialize: ->
    super
    # TODO Find a way to update the layout without using an interval. One way
    # could be using the resize event or a later callback or initial call to 
    # @onWindowSizeChange
    window.setInterval @onWindowSizeChange, 1500
    
  onWindowSizeChange: =>
    windowHeight = $(window).height()
    # info
    infoView = @subview 'info'
    configView = @subview 'config'
    # map
    @mapView = @subview 'map'
    @mapView.position 0, configView.$el.outerHeight()
    @mapView.resize(
      $(window).width(),
      windowHeight - infoView.$el.outerHeight() - configView.$el.outerHeight()
    )
    @positionMarkerView = @subview 'positionMarker'
    @positionMarkerView.reCenter()
    @

  renderSubviews: ->
    # map
    @subview 'map', new MapView
      container: @$el
      containerMethod: 'append'
    # add a marker for the geolocation of the client
    geolocation = new Geolocation
    @subview 'positionMarker', new GeolocationMarkerView
      map: @subview('map').map
      model: geolocation
    @subview 'route', new MapRouteView
      map: @subview('map').map
      model: geolocation
    @subview 'info', new GeolocationInfoView
      model: geolocation
      container: @$el
      containerMethod: 'append'
    @subview 'config', new ConfigView
      model: new Config
    super

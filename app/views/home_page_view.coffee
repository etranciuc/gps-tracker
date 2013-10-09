define [
  'models/config'
  'models/route'
  'views/templates/home'
  'views/base/page_view'
  'views/config_view'
  'views/geolocation_marker_view'
  'views/map_view'
  'views/map_route_view'
  'views/geolocation_info_view'
  'views/geolocation_accuracy_circle_view'
  'views/geolocation_pulse_circle_view'
  'models/geolocation'
], (Config, Route, template, PageView, ConfigView, GeolocationMarkerView, MapView, MapRouteView, GeolocationInfoView, GeolocationAccuracyCircleView, GeolocationPulseCircleView, Geolocation) ->
  'use strict'

  class HomePageView extends PageView

    id: 'home-page-view'

    autoRender: true
    template: template

    geolocation: null
    route: null
    config: null

    listen:
      'application:resize mediator': 'onApplicationResize'

    initialize: ->
      super
      # configuration of the map view and route tracking
      @config = new Config

      # central point of interest is the geolocation of the client
      @geolocation = new Geolocation
      # enable random updates (when debugging)
      @geolocation.startRandomUpdates 5000
      # @geolocation.startWatchPosition()
      
      @route = new Route
      # add a changed geoposition to the route if tracking is enabled
      @geolocation.on 'change:longitude change:latitude', (position) =>
        if @config.get 'trackRoute'
          @route.add position.toJSON()

      # bind events to geolocation changes and config
      @geolocation.on 'change:longitude change:latitude', (position) =>
        mapView = @subview 'map'
        if @config.get('autoCenter') and mapView
          mapView.setCenter @geolocation

      # bind event to config changes
      @config.on 'change:autoCenter', (config, value) =>
        mapView = @subview 'map'
        if value and mapView
          mapView.setCenter @geolocation
      @config.on 'change:trackRoute', (config, value) =>
        if value is false
          @route.reset()
        else
          @route.add @geolocation

    onApplicationResize: (size) =>
      # info
      infoView = @subview 'info'
      configView = @subview 'config'
      # map
      @mapView = @subview 'map'
      @mapView.position 0, configView.$el.height()
      @mapView.resize(
        size.width,
        size.height - infoView.$el.height() - configView.$el.height()
      )
      @

    renderSubviews: ->
      super
      @subview 'config', new ConfigView
        model: @config
      # map
      @subview 'map', new MapView
        container: @$el
        containerMethod: 'append'
      @subview 'info', new GeolocationInfoView
        model: @geolocation
        container: @$el
        containerMethod: 'append'
      # add view for the route
      @subview 'route', new MapRouteView
        map: @subview('map').map
        collection: @route
      # add a marker for the geolocation of the client
      @subview 'positionMarker', new GeolocationMarkerView
        map: @subview('map').map
        model: @geolocation
      @subview 'accuracyMarker', new GeolocationAccuracyCircleView
        model: @geolocation
        map: @subview('map').map
      @subview 'pulseMarker', new GeolocationPulseCircleView
        model: @geolocation
        map: @subview('map').map
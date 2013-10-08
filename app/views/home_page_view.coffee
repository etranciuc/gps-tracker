define [
  'models/config'
  'views/templates/home'
  'views/base/page_view'
  'views/config_view'
  'views/geolocation_marker_view'
  'views/map_view'
  'views/map_route_view'
  'views/geolocation_info_view'
  'views/geolocation_accuracy_circle_view'
  'models/geolocation'
], (Config, template, PageView, ConfigView, GeolocationMarkerView, MapView, MapRouteView, GeolocationInfoView, GeolocationAccuracyCircleView, Geolocation) ->
  'use strict'

  class HomePageView extends PageView

    id: 'home-page-view'

    autoRender: true
    template: template

    geolocation: null
    config: null

    listen:
      'application:resize mediator': 'onApplicationResize'

    initialize: ->
      super
      # central point of interest is the geolocation of the client
      @geolocation = new Geolocation
      @geolocation.startWatchPosition()
      # @geolocation.watchPosition()

      @config = new Config

      # bind events to geolocation changes and config
      @geolocation.on 'change:longitude change:latitude', (position) =>
        mapView = @subview 'map'
        if @config.get('autoCenter') and mapView
          mapView.setCenter @geolocation

      # bind event to config changes
      @config.on 'change:trackRoute', (config, value) =>
        if value
          @subview 'route', new MapRouteView
            map: @subview('map').map
            model: @geolocation
        else
          @subview('route').dispose()

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
      # add a marker for the geolocation of the client
      @subview 'positionMarker', new GeolocationMarkerView
        map: @subview('map').map
        model: @geolocation
      @subview 'accuracyMarker', new GeolocationAccuracyCircleView
        model: @geolocation
        map: @subview('map').map
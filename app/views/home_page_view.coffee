define [
  'models/config'
  'views/templates/home'
  'views/base/page_view'
  'views/config_view'
  'views/geolocation_marker_view'
  'views/map_view'
  'views/map_route_view'
  'views/geolocation_info_view'
  'models/geolocation'
], (Config, template, PageView, ConfigView, GeolocationMarkerView, MapView, MapRouteView, GeolocationInfoView, Geolocation) ->
  'use strict'

  class HomePageView extends PageView

    id: 'home-page-view'

    template: template

    geolocation: null
    config: null

    initialize: ->
      super
      # central point of interest is the geolocation of the client
      @geolocation = new Geolocation
      @config = new Config

      # bind events to geolocation changes and config
      @geolocation.on 'change:longitude change:latitude', (position) =>
        if @config.get 'autoCenter'
          mapView = @subview 'map'
          mapView.setCenter(@geolocation)

      # bind event to config changes
      @config.on 'change:trackRoute', (config, value) =>
        if value
          @subview 'route', new MapRouteView
            map: @subview('map').map
            model: @geolocation
        else
          @subview('route').dispose()
        
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
      @mapView.position 0, configView.$el.height()
      @mapView.resize(
        $(window).width(),
        windowHeight - infoView.$el.height() - configView.$el.height()
      )
      @

    renderSubviews: ->
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
      super
template = require 'views/templates/home'
PageView = require 'views/base/page_view'
MapView = require 'views/map_view'
Geolocation = require 'models/geolocation'
GeolocationMarkerView = require 'views/geolocation_marker_view'
GeolocationInfoView = require 'views/geolocation_info_view'

module.exports = class HomePageView extends PageView

  id: 'home-page-view'

  template: template

  initialize: ->
    super
    window.setInterval @onWindowSizeChange, 500
    
  onWindowSizeChange: =>
    windowHeight = $(window).height()
    # info
    @infoView = @subview 'info'
    # map
    @mapView = @subview 'map'
    @mapView.$el.css
      height: windowHeight - @infoView.$el.outerHeight()
      widht: $(window).width()
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
    @subview 'info', new GeolocationInfoView
      model: geolocation
      container: @$el
      containerMethod: 'append'
    super

define [
  'views/base/view'
], (View, Route) ->
  'use strict'

  # refactor together with other shape-based overlays to view
  class MapRouteView extends View

    options: 
      strokeColor: '#0080ff'
      strokeOpacity: 0.5
      strokeWeight: 10

    # stores an instance of the polyline which is rendered on the map
    polyline: null

    listen:
      'add collection': 'onCollectionAdd'
      'reset collection': 'onCollectionReset'

    initialize: =>
      # create polyline if not allready there
      unless @polyline
        @polyline = new google.maps.Polyline @options
      super

    dispose: =>
      if @polyline
        @polyline.setMap null
      super

    onCollectionAdd: (model, collection) =>
      path = @polyline.getPath()
      path.push model.get 'latLng'
      @

    onCollectionReset: (collection) =>
      @polyline.setPath collection.pluck 'latLng'
      @
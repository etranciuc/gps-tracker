define [
  'views/base/view'
], (View) ->
  'use strict'

  class MarkerView extends View

    autoRender: yes

    marker: null

    listen:
      'change:longitude model': 'onPositionChange'
      'change:latitude model': 'onPositionChange'

    render: ->
      options = _.defaults
        map: @options.map, @options
      @marker = new google.maps.Marker options
      # click event handler
      google.maps.event.addListener @marker, 'click', @onClick
      super

    onClick: (event) =>
      @trigger 'click', @, event
      @

    onPositionChange: (geoposition) =>
      @marker.setPosition @model.get 'latLng'
      @
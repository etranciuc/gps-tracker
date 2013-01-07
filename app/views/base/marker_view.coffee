View = require 'views/base/view'

module.exports = class MarkerView extends View

  autoRender: yes

  marker: null

  initialize: ->
    super
    @modelBind 'change:longitude change:latitude', @onPositionChange

  render: ->
    options = _(@options).defaults
      map: @options.map
      position: @model.get 'latLng'
    @marker = new google.maps.Marker options
     # click event handler
    google.maps.event.addListener @marker, 'click', @onClick
    return @$el

  onClick: (event) =>
    @trigger 'click', @, event
    @

  onPositionChange: (geoposition) =>
    @marker.setPosition @model.get 'latLng'
    @
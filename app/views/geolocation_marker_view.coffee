define [
  'views/base/marker_view'
], (MarkerView) ->
  
  # @TODO create own view for markers with image icons
  class GeolocationMarkerView extends MarkerView

    options:
      clickable: false

    render: ->
      super
      
      # replace icon
      imageSize = 32
      image = new google.maps.MarkerImage 'images/poi.png',
        new google.maps.Size(imageSize, imageSize),
        new google.maps.Point(0,0),
        new google.maps.Point(imageSize / 4, imageSize / 4)
        new google.maps.Size(imageSize / 2, imageSize / 2),
      @marker.setIcon image

      @
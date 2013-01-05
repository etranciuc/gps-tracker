template = require 'views/templates/geolocation_info'
View = require 'views/base/view'

module.exports = class GeolocationInfoView extends View

  id: 'info'
  template: template
  autoRender: yes

  initialize: ->
    super
    @modelBind 'change', @render
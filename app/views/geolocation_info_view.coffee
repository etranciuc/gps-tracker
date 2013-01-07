template = require 'views/templates/geolocation_info'
View = require 'views/base/view'

module.exports = class GeolocationInfoView extends View

  id: 'info'
  template: template
  autoRender: yes

  $errEl: null

  initialize: ->
    super
    @modelBind 'change', @render
    @model.on 'error', @onModelError

  afterRender: ->
    super
    @$errEl = @$el.find('.error')
    @$errEl.hide()

  onModelError: (geolocation, error) =>
    @$errEl.html(
      """
      Error (#{error.code}): #{error.message}
      """)
    @$errEl.show()
    @
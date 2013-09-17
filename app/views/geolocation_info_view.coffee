define [
  'views/base/view'
  'views/templates/geolocation_info'
], (View, template) ->
  'use strict'

  class GeolocationInfoView extends View

    id: 'info'
    template: template
    autoRender: yes

    $errEl: null

    listen:
      'change model': 'render'
      'error model': 'onModelError'

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
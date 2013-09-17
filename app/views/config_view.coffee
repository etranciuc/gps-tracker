define [
  'views/base/view'
  'views/templates/config'
], (View, template) ->
  'use strict'

  class ConfigView extends View

    autoRender: yes
    template: template
    container: '#app'

    className: 'navbar navbar-fixed'

    id: "config"

    listen: 
      'change model': 'onModelChange'

    initialize: ->
      super
      @delegate 'click', '.btn-track-route', =>
        @model.set 'trackRoute', !@model.get 'trackRoute';
      @delegate 'click', '.btn-auto-center', =>
        @model.set 'autoCenter', !@model.get 'autoCenter';

    onModelChange: =>
      @$el.find('.btn-track-route').toggleClass 'btn-active', @model.get 'trackRoute'
      @$el.find('.btn-auto-center').toggleClass 'btn-active', @model.get 'autoCenter'

    render: =>
      super
      @onModelChange()
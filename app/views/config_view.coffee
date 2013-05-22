View = require 'views/base/view'
template = require 'views/templates/config'

module.exports = class ConfigView extends View

  autoRender: yes
  template: template
  container: '#app'

  id: "config"

  initialize: ->
    super
    @modelBind 'change', @onModelChange
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
mediator = require 'mediator'
View = require 'views/base/view'

module.exports = class PageView extends View
  
  autoRender: yes

  container: '#app'

  initialize: ->
    super
    if @model or @collection
      rendered = no
      @modelBind 'change', =>
        @render() unless rendered
        rendered = yes

  renderSubviews: ->
    return

  render: ->
    super
    unless @renderedSubviews
      @renderSubviews()
      @renderedSubviews = yes

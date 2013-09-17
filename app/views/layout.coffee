define [
  'chaplin'
], (Chaplin) ->
  'use strict'
  
  class Layout extends Chaplin.Layout

    initialize: ->
      super
      $(window).on 'resize', ->
        Chaplin.mediator.publish 'application:resize',
          width: $(window).width()
          height: $(window).height()
      window.setTimeout ->
          $(window).trigger 'resize'
        ,
        1000
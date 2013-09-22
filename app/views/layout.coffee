define [
  'chaplin'
], (Chaplin) ->
  'use strict'
  
  class Layout extends Chaplin.Layout

    initialize: ->
      super

      # detect iOS7 system and add class to body tag to add more styles
      if Support.isIOS7()
        $('body').addClass('iOS7')

      # push application:resize event everytime the window size changes
      $(window).on 'resize', ->
        Chaplin.mediator.publish 'application:resize',
          width: $(window).width()
          height: $(window).height()
      # trigger first resize event to get application layout done right
      # @TODO refactor this issue by rendering everything when it’s ready
      window.setTimeout ->
          $(window).trigger 'resize'
        ,
        1000
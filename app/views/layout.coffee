define [
  'chaplin'
  'lib/support'
], (Chaplin, Support) ->
  'use strict'
  
  class Layout extends Chaplin.Layout

    initialize: ->
      super

      # detect iOS7 system and add class to body tag to add more styles
      if Support.isIOS() && Support.isIOS7()
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

      # auto detect day/night mode changes
      window.setInterval @autoTheme, 1000

    autoTheme: =>
      hour = (new Date).getHours()
      # check if it’s night time and switch over to night theme
      if 6 <= hour <= 17
        newTheme = 'default'
      else
        newTheme = 'night'
      # only publish event if theme is changed  
      if @lastTheme isnt newTheme
        Chaplin.mediator.publish 'application:config:change:theme', newTheme, @lastTheme
        @lastTheme = newTheme
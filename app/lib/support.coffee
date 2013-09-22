define [
  'chaplin'
], (Chaplin) ->
  'use strict'

  # Application-specific feature detection
  # --------------------------------------

  support = 
    isIOS: ->
      return !!document.location.href.match /\.app\/www/
    isAndroid: ->
      return !!document.location.href.match /android_asset/  
    isMobile: ->
      return @isIOS() or @isAndroid()
    isIOS7: ->
      # detect ios7 on the screen width and height
      viewPort = 
        width: window.innerWidth
        height: window.innerHeight
      console.log "viewPort detected: #{viewPort.width}x#{viewPort.height}"
      if viewPort.width == 320 and viewPort.height == 568
        return true
      if viewPort.width == 320 and viewPort.height == 480
        return true
      return false
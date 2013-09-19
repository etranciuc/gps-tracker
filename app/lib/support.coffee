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
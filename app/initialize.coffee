support = require 'lib/support'
Config = require 'config'
Application = require 'application'

# There are some libs not include
# 
window.googleMapsInitialize = () ->
  app = new Application()
  app.initialize()
callbackCordovaLibLoaded = ->
  url = "http://maps.googleapis.com/maps/api/js?v=3.exp&sensor=true&callback=window.googleMapsInitialize&sensor=true"  
  $.getScript url

if support.isIOS()
  $.getScript 'javascripts/cordova-2.7.0-ios.js', callbackCordovaLibLoaded
else if support.isAndroid()
  $.getScript 'javascripts/cordova-2.7.0-android.js', callbackCordovaLibLoaded
else
  callbackCordovaLibLoaded()
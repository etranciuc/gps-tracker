'use strict'

# Configure the AMD module loader
require.config
  # base path for all scripts
  baseUrl: 'js/source'
  # Specify the paths of vendor libraries
  paths:
    backbone: 'vendor/backbone.1.0.0.min'
    chaplin: 'vendor/chaplin.0.11.1'
    handlebars: 'vendor/handlebars.1.0.0'
    underscore: 'vendor/underscore.1.5.2.min'
    zepto: 'vendor/zepto.1.0.min'
    cordovaAndroid: 'vendor/cordova-2.7.0-android'
    cordovaIOS: 'vendor/cordova-3.0.0-ios'
  # auto-loading dependencies should be defined here
  shim:
    application:
      deps: [
        'chaplin'
        'handlebars'
        'controllers/home_controller'
      ]
    backbone:
      deps: [
        'zepto'
        'underscore'
      ]
      exports: 'Backbone'
    chaplin:
      deps: [
        'backbone'
      ]
      exports: 'Chaplin'
    handlebars:
      exports: 'Handlebars'
    underscore:
      exports: '_'
    zepto:
      exports: '$'
  # Extra query string arguments appended to URLs that RequireJS uses to fetch
  # resources. Most useful to cache bust when the browser or server is not
  # configured correctly. 
  urlArgs: 'bust=' + (new Date()).getTime()

require ['config', 'lib/support'], (Config, support) ->
  window.googleMapsInitialize = ->
    libs = [
      "application"
      "routes"
    ]
    if support.isIOS()
      libs.push 'cordovaIOS'
    else if support.isAndroid()
      libs.push 'cordovaAndroid'
      
    require libs, (Application, routes, Cordova) ->
      app = new Application
        routes: routes
        pushState: false

  require ["http://maps.googleapis.com/maps/api/js?sensor=true&key=#{Config.google.maps.key}&callback=googleMapsInitialize"]
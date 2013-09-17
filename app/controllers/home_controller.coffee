define [
  'controllers/base/controller'
  'views/home_page_view'
], (Controller, HomePageView) ->
  'use strict'

  class HomeController extends Controller

    index: ->
      @view = new HomePageView
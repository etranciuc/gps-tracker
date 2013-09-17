define [
  'chaplin'
  'config'
  'views/layout'
], (Chaplin, Config, Layout) ->
  'use strict'

  # The application object
  class Application extends Chaplin.Application

    layout: Layout

    # Set your application name here so the document title is set to
    # “Controller title – Site title” (see Layout#adjustTitle)
    title: Config.app.name
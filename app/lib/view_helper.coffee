define [
  'handlebars'
], (Handlebars) ->
  'use strict'

  # Make 'with' behave a little more mustachey
  Handlebars.registerHelper 'with', (context, options) ->
    if not context or Handlebars.Utils.isEmpty context
      options.inverse(this)
    else
      options.fn(context)

  Handlebars.registerHelper 'formatNumber', (value, precision = 0, suffix = null) ->
    unless typeof value is 'number'
      return '-'
    string = value.toFixed precision
    if typeof suffix is 'string'
      string += suffix
    return string
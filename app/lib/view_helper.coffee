mediator = require 'mediator'
utils = require 'chaplin/lib/utils'

# Application-specific view helpers
# ---------------------------------

# http://handlebarsjs.com/#helpers

# Make 'with' behave a little more mustachey
Handlebars.registerHelper 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)

Handlebars.registerHelper 'formatNumber', (value, precision) ->
  unless typeof value is 'number'
    return false
  unless precision?
    precision = 0
  return value.toFixed(precision)
Chaplin = require 'chaplin'
utils = require 'lib/utils'

# Application-specific feature detection
# --------------------------------------

# Delegate to Chaplin’s support module
support = utils.beget Chaplin.support

_(support).extend
  isIOS: ->
    return !!document.location.href.match /\.app\/www/
  isAndroid: ->
    return !!document.location.href.match /android_asset/  

module.exports = support
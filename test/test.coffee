require [
  '../../js/source/main'
], (RequireJSConfig) ->

  requirejs.config
    baseUrl: '../js/source'

  mocha.ui 'bdd'
  mocha.reporter 'html'
  mocha.ignoreLeaks yes

  assert = chai.assert
  should = chai.should()
  # make expect available in all tests
  window.expect = chai.expect

  specsBase = '../../test/js'
  specs = [
    "#{specsBase}/lib/utils_test"
    "#{specsBase}/lib/view_helper_test"
    "#{specsBase}/models/config_test"
    "#{specsBase}/models/geolocation_test"
  ]

  require specs, ->
    if window.mochaPhantomJS
      mochaPhantomJS.run()
    else
      mocha.run()
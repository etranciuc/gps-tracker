define [
  'models/base/model'
], (Model) ->
  'use strict'
  
  class Config extends Model

    defaults: 
      trackRoute: false
      autoCenter: true
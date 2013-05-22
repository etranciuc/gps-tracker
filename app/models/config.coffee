Model = require 'models/base/model'

module.exports = class Config extends Model

  defaults: 
    trackRoute: false
    autoCenter: true
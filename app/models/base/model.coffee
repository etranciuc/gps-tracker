module.exports = class Model extends Chaplin.Model

  getters: {}
  setters: {}

  get: (attr) ->
    if _.isFunction(@getters[attr]) 
      method = @getters[attr]
    else
      method = Backbone.Model::get
    return method.call @, attr

  set: (key, value, options) ->
    # normalize like in backbone core
    if _.isObject(key) or key is null
      attrs = key
      options = value
    else
      attrs = {}
      attrs[key] = value
    # iterate over fields
    for attr of attrs
      if _.isFunction @setters[attr]
        attrs[attr] = @setters[attr].call(this, attrs[attr])
    return Backbone.Model::set.call @, attrs, options
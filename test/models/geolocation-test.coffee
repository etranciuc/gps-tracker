Geolocation = require 'models/geolocation'

describe 'Geolocation Model', ->
  beforeEach ->
    @model = new Geolocation

  afterEach ->
    @model.dispose()

  it 'should have some default settings', ->
    expect(@model.get 'trackRoute').to.be.false

  describe 'setters:accuracy', ->
    it 'should not accept values below zero', ->
      @model.set 'accuracy', -1
      expect(@model.get 'accuracy').to.be.false

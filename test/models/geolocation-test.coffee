Geolocation = require 'models/geolocation'

describe 'Geolocation Model', ->
  beforeEach ->
    @model = new Geolocation

  afterEach ->
    @model.dispose()

  it 'should have some default settings', ->
    expect(@model.get 'trackRoute').to.be.false

  describe 'setters', ->
    describe 'accuracy', ->
      it 'should not accept values below zero', ->
        @model.set 'accuracy', -1
        expect(@model.get 'accuracy').to.be.false
    describe 'heading', ->
      it 'should accept values between 0° and 360°', ->
        values = [
          # values that should set to false
          [-1,      false]
          [361,     false]
          ['',      false]
          [null,    false]
          ['1',     false]
          [true,    false]
          [false,   false]
          # valid values
          [0,       0]
          [0.001,   0.001]
          [359.1,   359.1]
          [360,     360]
        ]
        for row in values
          @model.set 'heading', row[0]
          expect(@model.get 'heading').to.equal row[1]
    describe 'speed', ->
      it 'should only accept values above 0', ->
        values = [
          # values that should set to false
          [-1,      false]
          # valid values
          [0,       0]
          [2,       2]
          [99999,   99999]
        ]
        for row in values
          @model.set 'speed', row[0]
          expect(@model.get 'speed').to.equal row[1]

  describe 'toString', ->
    it 'should format unknown positions', ->
      result = @model.toString()
      epect(result).to.equal 'unknown'
    it 'should format positions with lat/lng', ->
      @model.set
        latitude: 12.3
        longitude: 15.5
      result = @model.toString()
      epect(result).to.equal '12.3, 15.5'
    it 'should include accuracy if set', ->
      @model.set
        latitude: 12.3
        longitude: 15.5
        accuracy: 5
      result = @model.toString()
      epect(result).to.equal '12.3, 15.5 (5m)'
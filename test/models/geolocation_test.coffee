define [
  'models/geolocation'
], (Geolocation) ->
  'use strict'

  describe 'Model:Geolocation', ->

    beforeEach ->
      attributes = 
        longitude: 27.174526
        latitude: 78.042153
        altitude: 200
        accuracy: 5
        speed: 10
      @model = new Geolocation attributes

    afterEach ->
      @model.dispose()

    describe 'setters', ->
      describe 'accuracy', ->
        it 'should not accept values below zero', ->
          @model.set 'accuracy', -1
          @model.get('accuracy').should.be.false
        it 'should accept values above zero', ->
          for value in [0.1, 1, 1000, 999]
            @model.set 'accuracy', value
            @model.get('accuracy').should.equal value
      describe 'heading', ->
        it 'should accept values between 0° and 360°', ->
          values = [
            # values that should set to false
            [-1,      false]
            [361,     false]
            # valid values
            [0,       0]
            [0.001,   0.001]
            [359.1,   359.1]
            [360,     360]
          ]
          for row in values
            @model.set 'heading', row[0]
            @model.get('heading').should.equal row[1]
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
            @model.get('speed').should.equal row[1]

    describe 'onPositionUpdate', ->
      it 'should use all other values passed', ->
        @model.onPositionUpdate
          coords:
            accuracy: 5
            longitude: 2.0
            latitude: 1.0
        @model.get('accuracy').should.equal 5
        @model.get('longitude').should.equal 2.0
        @model.get('latitude').should.equal 1.0
      describe 'lastUpdate', ->
        it 'should set lastUpdate to Date if not passed', ->
          @model.onPositionUpdate
            coords: {}
          @model.get('lastUpdate').should.be.instanceOf Date
        it 'should use the Date which is passed', ->
          date = new Date
          @model.onPositionUpdate
            coords: {}
            timestamp: date
          @model.get('lastUpdate').should.equal date
        it 'should convert timestamps in seconds to Date', ->
          timestamp = 1381396828792
          @model.onPositionUpdate
            coords: {}
            timestamp: timestamp
          @model.get('lastUpdate').should.be.instanceOf Date
          @model.get('lastUpdate').getFullYear().should.equal 2013
        it 'should convert timestamps in milliseconds to Date', ->
          timestampMilliseconds = 1381396828792 * 1000
          @model.onPositionUpdate
            coords: {}
            timestamp: timestampMilliseconds
          @model.get('lastUpdate').should.be.instanceOf Date
          @model.get('lastUpdate').getFullYear().should.equal 2013

    describe 'toString', ->
      it 'should format unknown positions', ->
        @model.set(@model.defaults)
        result = @model.toString()
        result.should.equal 'unknown'
      it 'should format lon/lat 0/0 correctly', ->
        @model.set(@model.defaults)
        @model.set
          longitude: 0
          latitude: 0
        @model.toString().should.equal '0/0'
      it 'should format positions with lat/lng', ->
        @model.set(@model.defaults)
        @model.set
          longitude: 15.5
          latitude: 12.3
        @model.toString().should.equal '15.5/12.3'
      it 'should include accuracy if set', ->
        @model.set
          longitude: 15.5
          latitude: 12.3
          accuracy: 5
        @model.toString().should.equal '15.5/12.3 (5m)'
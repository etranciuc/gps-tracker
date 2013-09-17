define [
  'lib/view_helper'
], (ViewHelper) ->
  'use strict'

  describe 'View Helper', ->

    describe 'Handlebars.formatNumber', ->
      method = Handlebars.helpers.formatNumber
      
      it 'should format numbers to strings', ->
        method(12).should.equal "12"
      it 'should use the "precision" parameter', ->
        method(12.1234, 2).should.equal '12.12'
        method(12.9999, 2).should.equal '13.00'
      it 'should use the "suffix" parameter', ->
        method(12, null, 'm').should.equal '12m'
      it 'should return "-" if "precision" and "suffix" parameter are empty', ->
        method(null, null, null).should.equal '-'

      it 'should format invalid numbers to "-"', ->
        invalidData = [
          null
          "string"
          {}
        ]
        for value in invalidData
          method(value).should.equal '-'
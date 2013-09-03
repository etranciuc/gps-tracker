Config = require 'models/config'

describe 'Config Model', ->
  beforeEach ->
    @model = new Config

  afterEach ->
    @model.dispose()

  it 'should have some default settings', ->
    expect(@model.get 'trackRoute').to.be.false
    expect(@model.get 'autoCenter').to.be.true

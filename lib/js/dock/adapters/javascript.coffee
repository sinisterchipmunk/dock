Adapter = require('dock/adapters/base').Base

class module.exports extends Adapter
  generate: ->
    [ @class "Dock", file: @filename ]

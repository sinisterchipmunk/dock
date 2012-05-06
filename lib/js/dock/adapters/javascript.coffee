Adapter = require('dock/adapters/base').Base

class module.exports extends Adapter
  generate: ->
    @root.classes.push @class "Dock", file: @filename

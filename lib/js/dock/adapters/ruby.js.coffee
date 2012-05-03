class module.exports
  constructor: (@filename, @contents) ->
  
  getNodes: ->
    [ file: @filename, type: "Class", name: "Dock" ]

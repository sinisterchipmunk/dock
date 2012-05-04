class module.exports
  constructor: (@filename, @contents) ->
    
  parse_tree: ->
    file: @filename
    type: "Block"
    classes: [ type: "Class", file: @filename, name: "Dock" ]

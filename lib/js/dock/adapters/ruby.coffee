class module.exports
  constructor: (@filename, @contents) ->
    
  parse_tree: ->
    file: @filename
    type: "Block"
    lines: [ type: "Class", file: @filename, name: "Dock" ]

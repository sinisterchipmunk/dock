node_types = 
  Block: "blocks"
  Literal: "literals"
  Class: "classes"
  Assign: "assigns"
  Value: "values"
  Return: "returns"
  Comment: "comments"
  Code: "codes"
  Param: "params"
  Splat: "splats"
  Access: "accesses"
  Index: "indexes"
  Slice: "slices"
  Obj: "objects"
  Call: "calls"
  Arr: "arrays"
  Range: "ranges"
  Try: "tries"
  Throw: "throws"
  Parens: "parens"
  While: "whiles"
  For: "fors"
  Switch: "switches"
  If: "ifs"
  Op: "operations"
  Extends: "extends"

class Node
  constructor: (nodes...) ->
    for type, accessor of node_types
      @[accessor] = []
    @push node for node in nodes
  
  @wrap = (ary) ->
    klass = exports[@type]
    throw new Error "No class found for type #{@type} in node #{@name}" unless klass
    new klass ary...
  
  meta: (type, accessor) ->
    @type = type
    Object.defineProperty @, "accessor",
      get: -> accessor
      enumerable: false
  
  push: (node) ->
    unless this[node.accessor]
      name = @__proto__.constructor.name
      type = @type || @__proto__.constructor.type
      throw new Error("No accessor found named #{node.accessor} in node #{type} (#{name})")
    this[node.accessor] or= []
    this[node.accessor].push node
    this

class exports.Literal extends Node
  constructor: (value) ->
    super()
    @value = value
    @meta "Literal", "literals"
    
class exports.Class extends Node
  constructor: (@name, @extends, block) ->
    super()
    @meta "Class", "classes"
    @push block if block



for type, accessor of node_types
  continue if exports[type]
  exports[type] = class extends Node
    [_type, _accessor] = [type, accessor]

    constructor: (args...) ->
      super args...
      @meta _type, _accessor
      
    @type: _type

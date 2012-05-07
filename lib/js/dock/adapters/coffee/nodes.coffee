{extend} = require 'dock/adapters/coffee/helpers'
exports.extend = extend  # for parser

class Node
  constructor: (@nodes...) ->
    @type = @__proto__.constructor.name
  children: -> []
  build: ->               
    for child in @children()
      if @[child] and @[child].build then @[child].build()
  
class exports.Literal extends Node
  constructor: (@value) -> super()
  toString: -> @value.toString()
    
class exports.Value extends Node
  constructor: (@base, @properties = [], @tag) -> super()
  children: -> ['base', 'properties', 'tag']
  add: (props) ->
    @properties = @properties.concat props
    this
  isObject: -> @base instanceof exports.Obj
  toString: ->
    name = @base.toString()
    for prop in @properties
      name += prop.toString()
    name

class exports.Class extends Node
  constructor: (@name, @extends, @block) -> super()
  children: -> ['name', 'extends', 'block']
  build: ->
    super()
    @properties = []
    for node in @block.lines
      if node instanceof exports.Value and node.isObject()
        @properties.push node.base
    # separate methods from variables in @properties
    @methods = []
    for obj in @properties
      desc = ""
      for prop in obj.props
        switch prop.type
          when 'Comment' then desc += prop.comment
          when 'Assign'                    
            name = prop.variable.toString()
            if prop.value instanceof exports.Code
              @methods.push name: name, documentation: desc, params: prop.value.params
            else
              # variable, not implemented yet
            desc = ""

    
class exports.Code extends Node
  constructor: (@params, @body, @tag) -> super()
  children: -> ['params', 'body', 'tag']
    
class exports.Assign extends Node
  constructor: (@variable, @value, @context, @options) -> super()
  children: -> ['variable', 'value', 'context', 'options']
  
class exports.Obj extends Node
  constructor: (@props, @generated = false) -> super()
  children: -> ['props', 'generated']
  
class exports.Call extends Node
  constructor: (@variable, @args = [], @soak) -> super()
  children: -> ['variable', 'args', 'soak']

class exports.Block extends Node
  constructor: (@lines = []) -> super()
  children: -> ['lines']
  push: (node) ->
    @lines.push node
    this
  build: ->
    node.build() for node in @lines
    doc = ""
    for line in @lines
      if line instanceof exports.Comment
        doc += line.comment
      else
        line.documentation = doc
        doc = ""
    
  @wrap = (ary) ->
    klass = exports.Block
    new klass ary

class exports.Return extends Node
  constructor: (@expr) -> super()
  children: -> ['expr']

class exports.Comment extends Node
  constructor: (@comment) -> super()
  children: -> ['comment']

class exports.Param extends Node
  constructor: (@name, @value, @splat) -> super()
  children: -> ['name', 'value', 'splat']
        
class exports.Splat extends Node
  constructor: (@name) -> super()
  children: -> ['name']

class exports.Access extends Node
  constructor: (@name, @tag) -> super()
  children: -> ['name', 'tag']
  toString: -> "." + @name.toString()

class exports.Index extends Node
  constructor: (@index) -> super()
  children: -> ['index']

class exports.Slice extends Node
  constructor: (@range) -> super()
  children: -> ['range']
  
class exports.Arr extends Node
  constructor: (@objs) -> super()
  children: -> ['objs']

class exports.Range extends Node
  constructor: (@from, @to, @tag) -> super()
  children: -> ['from', 'to', 'tag']

class exports.Try extends Node
  constructor: (@attempt, @error, @recovery, @ensure) -> super()
  children: -> ['attempt', 'error', 'recovery', 'ensure']

class exports.Throw extends Node
  constructor: (@expression) -> super()
  children: -> ['expression']
  
class exports.Parens extends Node
  constructor: (@body) -> super()
  children: -> ['body']

class exports.While extends Node
  constructor: (@condition, @options) -> super()
  addBody: (@body) -> @
  children: -> ['condition', 'options', 'body']

class exports.For extends Node
  constructor: (@body, @source) -> super()
  children: -> ['body', 'source']

class exports.Switch extends Node
  constructor: (@subject, @cases, @otherwise) -> super()
  children: -> ['subject', 'cases', 'otherwise']

class exports.If extends Node
  constructor: (@condition, @body, @options = {}) -> super()
  addElse: (@else) -> @
  children: -> ['condition', 'body', 'options', 'else']

class exports.Op extends Node
  constructor: (@op, @first, @second, @flip) ->
    super()
    @inverted = false
  children: -> ['op', 'first', 'second', 'flip', 'inverted']
  invert: ->
    @inverted = true
    this

class exports.Extends extends Node
  constructor: (@child, @parent) -> super()
  children: -> ['child', 'parent']

class exports.Existence extends Node
  constructor: (@expression) -> super()
  children: -> ['expression']

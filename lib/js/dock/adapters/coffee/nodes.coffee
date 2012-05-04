class Node
  constructor: (@nodes...) ->
    @type = @__proto__.constructor.name
  
class exports.Literal extends Node
  constructor: (@value) -> super()
    
class exports.Value extends Node
  constructor: (@base, @props, @tag) -> super()

class exports.Class extends Node
  constructor: (@name, @extends, @block) -> super()
    
class exports.Code extends Node
  constructor: (@params, @body, @tag) -> super()
    
class exports.Assign extends Node
  constructor: (@variable, @value, @context, @options) -> super()
  
class exports.Obj extends Node
  constructor: (@props, @generated = false) -> super()
  
class exports.Call extends Node
  constructor: (@variable, @args = [], @soak) -> super()

class exports.Block extends Node
  constructor: (@lines) -> super()
  push: (node) ->
    @lines.push node
    this
    
  @wrap = (ary) ->
    klass = exports.Block
    new klass ary

class exports.Return extends Node
  constructor: (@expr) -> super()

class exports.Comment extends Node
  constructor: (@comment) -> super()

class exports.Param extends Node
  constructor: (@name, @value, @splat) -> super()
        
class exports.Splat extends Node
  constructor: (@name) -> super()

class exports.Access extends Node
  constructor: (@name, @tag) -> super()

class exports.Index extends Node
  constructor: (@index) -> super()

class exports.Slice extends Node
  constructor: (@range) -> super()
  
class exports.Arr extends Node
  constructor: (@objs) -> super()

class exports.Range extends Node
  constructor: (@from, @to, @tag) -> super()

class exports.Try extends Node
  constructor: (@attempt, @error, @recovery, @ensure) -> super()

class exports.Throw extends Node
  constructor: (@expression) -> super()
  
class exports.Parens extends Node
  constructor: (@body) -> super()

class exports.While extends Node
  constructor: (@condition, @options) -> super()

class exports.For extends Node
  constructor: (@body, @source) -> super()

class exports.Switch extends Node
  constructor: (@subject, @cases, @otherwise) -> super()

class exports.If extends Node
  constructor: (@condition, @body, @options = {}) -> super()

class exports.Op extends Node
  constructor: (@op, @first, @second, @flip ) -> super()

class exports.Extends extends Node
  constructor: (@child, @parent) -> super()

class exports.Existence extends Node
  constructor: (@expression) -> super()

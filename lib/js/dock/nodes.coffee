# This file describes nodes that represent components
# of a project's documentation. Adapters are expected
# to parse files, and ultimately produce a tree of
# the nodes defined below.

exports.Node = class Node
  common = (array, node, name, options) ->
    array.push node
    node.name = name
    node.documentation = options.documentation || ""
    node.file = options.file
    node
  
  constructor: (@type, name = null, options = {}) ->
    @classes   = []
    @modules   = []
    @methods   = []
    @constants = []
    @variables = []
    @name = name
    for k, v of options
      @[k] = v
    @description or= ""

  module: (name, options = {}) ->
    @modules.push module = new Module name, options
    module
    
  class: (name, options = {}) ->
    @classes.push klass = new Class name, options
    klass
    
  method: (name, options = {}) ->
    @methods.push method = new Method name, options
    method
  
  constant: (name, options = {}) ->
    @constants.push constant = new Constant name, options
    constant
    
  variable: (name, options = {}) ->
    @variables.push variable = new Variable name, options
    variable

exports.Module = class Module extends Node
  constructor: (name, options = {}) ->
    super 'Module', name, options

exports.Class = class Class extends Node
  constructor: (name, options = {}) ->
    super 'Class', name, options
    @superclass or= null

exports.Method = class Method extends Node
  constructor: (name, options = {}) ->
    super 'Method', name, options

exports.Constant = class Constant extends Node
  constructor: (name, options = {}) ->
    super 'Constant', name, options

exports.Variable = class Variable extends Node
  constructor: (name, options = {}) ->
    super 'Variable', name, options

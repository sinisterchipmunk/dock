{Lexer,RESERVED} = require 'dock/adapters/coffee/lexer'
{parser}         = require 'dock/adapters/coffee/parser'
# {parser}         = require 'dock/adapters/coffee/grammar'

class module.exports
  constructor: (@filename, @contents) ->
    @nodes = []
    @parse_tree()
  
  parse_tree: ->
    
  
  getNodes: ->
    @nodes
  
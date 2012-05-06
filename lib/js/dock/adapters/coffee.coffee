{Lexer,RESERVED} = require 'dock/adapters/coffee/lexer'
{parser}         = require 'dock/adapters/coffee/parser'
{Node}           = require 'dock/nodes'
Adapter = require('dock/adapters/base').Base

class module.exports extends Adapter
  process_tree: (block, node) ->
    block.build()
    for line in block.lines
      switch line.type
        when 'Class'
          node.classes.push @process_tree line.block, @class line.name.toString(),
            file: @filename
            documentation: line.documentation
    node
  
  generate: ->
    @process_tree parser.parse(lexer.tokenize @contents), @root
  
# Instantiate a Lexer for our use here.
lexer = new Lexer

# The real Lexer produces a generic stream of tokens. This object provides a
# thin wrapper around it, compatible with the Jison API. We can then pass it
# directly as a "Jison lexer".
parser.lexer =
  lex: ->
    [tag, @yytext, @yylineno] = @tokens[@pos++] or ['']
    tag
  setInput: (@tokens) ->
    @pos = 0
  upcomingInput: ->
    ""

parser.yy = require 'dock/adapters/coffee/nodes'

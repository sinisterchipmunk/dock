{Lexer,RESERVED} = require 'dock/adapters/coffee/lexer'
{parser}         = require 'dock/adapters/coffee/parser'
Adapter = require('dock/adapters/base').Base

class module.exports extends Adapter
  process_tree: (nodes, block) ->
    for line in block.lines
      switch line.type
        when 'Class'
          nodes.push @class line.name.toString(),
            file: @filename
    nodes
  
  generate: ->
    @process_tree [], parser.parse lexer.tokenize @contents
  
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

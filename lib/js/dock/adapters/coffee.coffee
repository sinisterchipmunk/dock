{Lexer,RESERVED} = require 'dock/adapters/coffee/lexer'
{parser}         = require 'dock/adapters/coffee/parser'

class module.exports
  constructor: (@filename, @contents) ->
    @parse_tree()
  
  parse_tree: ->
    parser.parse lexer.tokenize @contents
  
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

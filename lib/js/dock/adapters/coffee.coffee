{Lexer,RESERVED} = require 'dock/adapters/coffee/lexer'
{parser}         = require 'dock/adapters/coffee/parser'
{Node}           = require 'dock/nodes'
Adapter = require('dock/adapters/base').Base

class module.exports extends Adapter
  process_tree: (block, node) ->
    block.build()
    for line in block.lines
      switch line.type
        when 'Assign'
          if line.value.type == 'Class'
            # TODO process the left side of assign, since that's effectively
            # the class name, or at least an alias
            klass_node = @process_class_tree block, node, line.value
            klass_node.documentation = line.documentation
        when 'Class'
          @process_class_tree block, node, line
    node
    
  process_class_tree: (block, node, klass) ->
    [instance_methods, class_methods] = [[], []]
    for method in klass.methods
      method_params = []
      for param in method.params
        method_params.push
          type: 'Param'
          name: param.name.toString()
          default: param.value && param.value.toString()
          documentation: param.documentation || ""
      
      if method.name.indexOf("this.") == 0
        class_methods.push @class_method method.name.substring(5, method.name.length),
          documentation: method.documentation
          params: method_params
      else
        instance_methods.push @instance_method method.name,
          documentation: method.documentation
          params: method_params

    node.classes.push klass_node = @process_tree klass.block, @class klass.name.toString(),
      file: @filename   
      language: 'coffee'
      documentation: klass.documentation
      instance_methods: instance_methods
      class_methods: class_methods
    klass_node
  
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

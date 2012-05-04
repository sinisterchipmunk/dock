exports.Adapters = class Adapters
  @rb:     require 'dock/adapters/ruby'
  @coffee: require 'dock/adapters/coffee'
  @js:     require 'dock/adapters/javascript'

  @process: (language, filename, contents) ->
    language or= filename.substring filename.lastIndexOf('.') + 1, filename.length
    
    if klass = this[language]
      root_node = new klass(filename, contents).parse_tree()
      root_node.file = filename
      root_node.language = language
      root_node
    else throw new Error "No adapter for file extension #{language}"
    
exports.Adapters = class Adapters
  @rb:     require 'dock/adapters/ruby'
  @coffee: require 'dock/adapters/coffee'

  @process: (filename, contents) ->
    ext = filename.substring filename.lastIndexOf('.') + 1, filename.length
    
    if klass = this[ext]
      return new klass(filename, contents).getNodes()
    else throw new Error "No adapter for file extension #{ext}"
    
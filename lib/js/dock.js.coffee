{Adapters} = require "dock/adapters"

class Dock
  constructor: ->
    @nodes = []
  
  # Adds a source file to be documented
  source: (filename, contents) ->
    @nodes.push node for node in Adapters.process(filename, contents)
    
  # Generates the documentation and returns it as a JSON object
  #
  # Accepts a set of file entries, each of which must be an array containing
  # [filename, contents].
  #
  # Example:
  #
  #    dock.generate(["file1", "file-content1"], ["file2", "file-content2"])
  #
  generate: (files...) ->
    for entry in files
      @source entry...
    @nodes

exports.generate = (files) -> new Dock().generate(files)

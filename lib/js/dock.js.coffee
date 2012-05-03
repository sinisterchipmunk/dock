class Dock
  constructor: ->
    @data = []
  
  # Adds a source file to be documented
  source: (filename, contents) ->
    # Push a node into the data stack. Note: each node should be discovered
    # by a source adapter after searching the file contents. That part's
    # not implemented yet. The adapter should return an array of nodes,
    # all of which will be added to @data.
    @data.push file: filename, type: "Class", name: "Dock"
    
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
    @toJSON()
    
  # Returns the JSON object containing the documentation data
  toJSON: -> @data

this.generate = (files) -> new Dock().generate(files)

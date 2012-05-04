{Adapters} = require "dock/adapters"

class Dock
  # Generates the documentation and returns it as a JSON object
  #
  # Accepts a single file entry.
  #
  # Example:
  #
  #    dock.generate('coffee', "file1", "file-content1")
  #
  generate: (language = null, filename, content) ->
    Adapters.process language, filename, content

exports.generate = (language = null, filename, content) -> new Dock().generate language, filename, content

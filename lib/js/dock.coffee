{Adapters} = require "dock/adapters"

###
  Responsible for generating documentation at a high level. Dock
  delegates calls for generation into Adapters, which selects the
  appropriate adapter depending on the language of the file being
  parsed.
###
class Dock
  ###
    Generates the documentation and returns it as a JSON object

    Accepts a single file entry.

    Example:

       dock.generate('coffee', "file1", "file-content1")
  ###
  generate: (language = null, filename, content) ->
    Adapters.process language, filename, content

exports.generate = (language = null, filename, content) -> new Dock().generate language, filename, content

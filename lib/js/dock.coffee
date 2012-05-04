{Adapters} = require "dock/adapters"

class Dock
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
    result = []
    result.push Adapters.process entry... for entry in files
    result

exports.generate = (files) -> new Dock().generate(files)

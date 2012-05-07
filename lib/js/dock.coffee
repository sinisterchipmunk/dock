{Adapters} = require "dock/adapters"

###
Responsible for generating documentation at a high level. `Dock`
delegates calls for generation into `Adapters`, which selects the
appropriate adapter depending on the language of the file being
parsed.
###
exports.Dock = class Dock
  ###
  Generates the documentation and returns it as a JSON object
  
    * `language` is 'coffee', 'js' or 'rb', or null to autodetect the
      language from the file extension.
    * `filename` is the relative file name, including extension, and
      will be attached to each node for reference and used to detect
      language if language is null.
    * `content` is the file content itself. `Dock` does not read from
      the file system.
  
  Example:
  
      new Dock().generate 'coffee', "file1", "file-content1"
  ###
  generate: (language = null, filename, content) ->
    Adapters.process language, filename, content
  
  ###
  Equivalent to instantiating `Dock` and then calling the instance
  method of the same name, this generates documentation for a single
  file.              
  
  Example:
  
      Dock.generate 'coffee', 'file1', 'file-content1'
  ###  
  @generate: (language = null, filename, content) ->
    new Dock().generate language, filename, content

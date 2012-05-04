require 'execjs'
require 'json'
require 'sprockets'

class Dock
  autoload :Version, "dock/version"
  autoload :VERSION, "dock/version"
  autoload :Node,    "dock/node"
  autoload :Nodes,   "dock/nodes"
  
  attr_accessor :path, :pattern, :code, :language

  def initialize(options = {})
    reset_options!
    
    options.each do |key, value|
      self.send(:"#{key}=", value)
    end

    if code && language && !options.key?(:path)
      @scan_files = false
    else
      @scan_files = true
    end
  end
  
  def reset_options!
    @path = "."
    @pattern = "**/*.{coffee,js,rb}"
  end
  
  def classes
    root_nodes.collect do |root_node|
      raising_with_file root_node.file do
        root_node.lines.select { |line| line.type == 'Class' }
      end
    end.flatten
  end
  
  def root_nodes
    generate.collect do |root_node|
      raising_with_file root_node['file'] do
        Dock::Node.new root_node
      end
    end
  end
  
  # The Sprockets environment which is responsible for building the Dock JavaScript sources.
  def source_compiler
    @source_compiler ||= Sprockets::Environment.new.tap do |env|
      env.append_path File.expand_path("lib/js")
    end
  end
  
  # Returns the Dock JavaScript source, as compiled by Sprockets.
  def source
    source = source_compiler['jison.js'].to_s
    source_compiler.each_logical_path do |logical_path|
      next if logical_path == 'jison.js'
      src = source_compiler[logical_path].to_s
      logical_path.sub! /\.js$/, ''
      source.concat "require.def('#{logical_path}',{factory:function(require,exports,module){#{src}}});"
    end
    source + "var Dock = require('dock');"
  end
  
  # Returns the ExecJS context, creating it if necessary.
  def context
    @context ||= ExecJS.compile source
  end
  
  # Builds the documentation for the project and returns it as an array of nodes
  def generate
    @generated ||= discovered_files.collect do |file|
      raising_with_file file[0] do
        context.call 'Dock.generate', language, *file
      end
    end
  end
  
  def raising_with_file(filename)
    yield
  rescue
    $!.message.concat " (while processing file #{filename})"
    raise $!
  end
  
  def discovered_files
    files = []
    if code and language
      files << [nil, code]
    end
    
    if @scan_files
      scan_path = File.expand_path(File.join(path, pattern))
      files += Dir[scan_path].select { |f| File.file?(f) }.collect do |absolute_path|
        relative_path = absolute_path.sub(/^#{Regexp::escape path}\/?/, '')
        contents = File.read absolute_path
        [relative_path, contents]
      end
    end
    
    files
  end
end

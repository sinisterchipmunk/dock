require 'execjs'
require 'json'
require 'sprockets'

class Dock
  autoload :Version, "dock/version"
  autoload :VERSION, "dock/version"
  autoload :Node,    "dock/node"
  autoload :Nodes,   "dock/nodes"
  
  attr_accessor :path, :pattern

  def initialize(options = {})
    reset_options!
    options.each do |key, value|
      self.send(:"#{key}=", value)
    end
  end
  
  def reset_options!
    @path = "."
    @pattern = "**/*"
  end
  
  def classes
    root_nodes.collect { |root_node| root_node.classes }.flatten
  end
  
  def root_nodes
    generate.collect { |node| Dock::Node.new node }
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
    context.call('Dock.generate', *discovered_files)
  end
  
  def discovered_files
    Dir[File.expand_path(File.join(path, pattern))].select { |f| File.file?(f) }.collect do |absolute_path|
      relative_path = absolute_path.sub(/^#{Regexp::escape path}\/?/, '')
      contents = File.read absolute_path
      [relative_path, contents]
    end
  end
end

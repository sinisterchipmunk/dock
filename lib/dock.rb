require 'execjs'
require 'json'
require 'sprockets'

class Dock
  autoload :Version, "dock/version"
  autoload :VERSION, "dock/version"
  require 'dock/class'
  
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
    generate.select { |node| node.kind_of?(Dock::Class) }
  end
  
  # The Sprockets environment which is responsible for building the Dock JavaScript sources.
  def source_compiler
    @source_compiler ||= Sprockets::Environment.new.tap do |env|
      env.append_path File.expand_path("lib/js")
    end
  end
  
  # Returns the Dock JavaScript source, as compiled by Sprockets.
  def source
    source_compiler['dock.js']
  end
  
  # Returns the ExecJS context, creating it if necessary.
  def context
    @context ||= ExecJS.compile source
  end
  
  # Builds the documentation for the project and returns it as an array of nodes
  def generate
    context.call('generate', *discovered_files).collect do |node|
      self.class.const_get(node['type']).new(node)
    end
  end
  
  def discovered_files
    Dir[File.expand_path(File.join(path, pattern))].select { |f| File.file?(f) }.collect do |absolute_path|
      relative_path = absolute_path.sub(/^#{Regexp::escape path}\/?/, '')
      contents = File.read absolute_path
      [relative_path, contents]
    end
  end
end

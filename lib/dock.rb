require 'execjs'
require 'json'
require 'sprockets'
require 'github/markup'

class Dock
  autoload :Version, "dock/version"
  autoload :VERSION, "dock/version"
  autoload :Node,    "dock/node"
  autoload :Nodes,   "dock/nodes"
  autoload :Template,"dock/template"
  
  attr_accessor :project_path, :pattern, :code, :language, :template_path, :title
  
  class << self
    attr_writer :markup
  
    # Returns the selected markup. If none has been explicitly set, the markup will
    # be auto-detected based on what markup gems have been included. If no markup is
    # found, an error will be raised.
    def markup
      @markup ||= begin
        markups = %w(markdown textile rdoc org creole mediawiki rst asciidoc pod)
        markups.select! do |markup|
          markup =~ GitHub::Markup.class_variable_get("@@markups").keys[0]
        end
        markups.first or raise "No markups found! Please install a markup gem like 'redcarpet'."
      end
    end
  end
  
  def initialize(options = {})
    reset_options!
    
    options.each do |key, value|
      self.send(:"#{key}=", value)
    end

    if code && language && !options.key?(:project_path) && !options.key?(:pattern)
      @scan_files = false
    else
      @scan_files = true
    end
  end
  
  def reset_options!
    @title = "Documentation"
    @project_path = "./lib"
    @pattern = "/**/*.{coffee,js,rb}"
    @template_path = File.expand_path("../templates", File.dirname(__FILE__))
  end
  
  def build_to(path)
    template = Dock::Template.new :title => title
    template.view_paths << template_path
    
    FileUtils.mkdir_p path
    classes.each do |node|
      template.node = node
      result = template.render :template => node.type.underscore, :layout => 'layout'
      File.open(File.join(path, "#{node.name.to_s.underscore}.html"), "w") do |f|
        f.puts result
      end
    end
  end
  
  def classes
    root_nodes.inject([]) do |classes, node|
      classes.concat node.classes
      classes
    end
  end
  
  # The Sprockets environment which is responsible for building the Dock JavaScript sources.
  def source_compiler
    @source_compiler ||= Sprockets::Environment.new.tap do |env|
      env.append_path File.expand_path("./js", File.dirname(__FILE__))
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
    source + "var Dock = require('dock').Dock;"
  end
  
  # Returns the ExecJS context, creating it if necessary.
  def context
    @context ||= ExecJS.compile source
  end
  
  # Builds the documentation for the project and returns it as an array of
  # nodes. Each node represents the documented file and contains information
  # about the objects contained in it.
  def root_nodes
    @nodes ||= discovered_files.collect do |file|
      raising_with_file file[0] do
        Dock::Node.new context.call('Dock.generate', language, *file)
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
      scan_path = File.expand_path project_path
      files += Dir[File.join(scan_path, pattern)].select { |f| File.file?(f) }.collect do |absolute_path|
        relative_path = absolute_path.sub(/^#{Regexp::escape scan_path}[\/\\]?/, '')
        contents = File.read absolute_path
        [relative_path, contents]
      end
    end
    
    files
  end
end

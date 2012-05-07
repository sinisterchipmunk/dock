require "bundler/gem_tasks"
require "bundler/setup"
require 'dock'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

COFFEE_PARSER = File.expand_path("lib/js/dock/adapters/coffee/parser.js", File.dirname(__FILE__))
COFFEE_GRAMMAR= File.expand_path("lib/js/dock/adapters/coffee/grammar.coffee", File.dirname(__FILE__))

desc "build documentation by running Dock against itself"
task :doc do
  dock = Dock.new :project_path => File.expand_path('.', File.dirname(__FILE__)),
                  :pattern => 'lib/js/**/*.{coffee}',
                  :title => "Dock"
  dock.build_to './doc'
end

namespace :coffee do
  desc "Rebuild the coffeescript parser"
  task :parser do
    context = Dock.new.context
    parser = context.eval <<-end_code
      (function() {
        require("jison");
        var parser = require("dock/adapters/coffee/grammar").parser
        return parser.generate();
      })()
    end_code
    
    File.open(COFFEE_PARSER, "w") do |f|
      f.puts parser
    end
    
    puts "Parser built."
  end
end

task :default do
  if File.stat(COFFEE_PARSER).mtime < File.stat(COFFEE_GRAMMAR).mtime
    Rake::Task['coffee:parser'].invoke
    puts
  end
  Rake::Task['spec'].invoke
end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dock/version"

Gem::Specification.new do |s|
  s.name        = "dock"
  s.version     = Dock::VERSION
  s.authors     = ["Colin MacKenzie IV"]
  s.email       = ["sinisterchipmunk@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "dock"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "therubyracer" # because execjs needs *something*
  s.add_development_dependency 'redcarpet' # for github-markup
  
  s.add_runtime_dependency "rake"
  s.add_runtime_dependency "execjs"
  s.add_runtime_dependency "sprockets"
  s.add_runtime_dependency 'coffee-script'
  s.add_runtime_dependency 'actionpack', '~> 3.2.3'
  s.add_runtime_dependency 'github-markup'
end

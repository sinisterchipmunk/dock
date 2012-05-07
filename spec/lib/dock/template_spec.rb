require 'spec_helper'

describe Dock::Template do                                          
	let(:dock) { Dock.new(:project_path => 'project') }
	let(:node) { Dock::Node.new('file' => 'lib/src/test.coffee', 'type' => 'Node') }
	subject { Dock::Template.new :dock => dock, :node => node, :destination_root => 'doc' }
	
	it "should construct new path relative to its current destination" do
		subject.path_to('lib/src/other.coffee').should == 'other.coffee'
	end
	
	it "should find relative path to root folder" do
		subject.path_to("stylesheet.css").should == "../../stylesheet.css"
	end
end

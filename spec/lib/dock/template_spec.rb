require 'spec_helper'

describe Dock::Template do                                          
	let(:dock) { Dock.new(:project_path => 'project') }
	let(:node) { Dock::Node.new('file' => 'lib/src/test.coffee', 'type' => 'Class', 'name' => 'Node') }
	let(:template) { Dock::Template.new :dock => dock, :node => node, :destination_root => 'doc' }
	
	it "should construct new path relative to its current destination" do
		template.path_to('lib/src/other.coffee').should == 'other.coffee'
	end
	
	it "should find relative path to root folder" do
		template.path_to("stylesheet.css").should == "../../stylesheet.css"
	end
	
	describe "method signature" do
		describe "given a constructor method" do
			let(:method) { Dock::Node.new('type' => 'InstanceMethod', :name => 'constructor', :params => []) }
			
			it "should use 'new ...'" do
				template.method_signature(method).should match(/^new Node/)
			end
		end
	end
end

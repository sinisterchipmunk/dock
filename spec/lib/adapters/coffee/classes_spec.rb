require 'spec_helper'

describe "Coffee adapter" do
  let(:project_path) { File.expand_path("../../../fixtures/coffee", File.dirname(__FILE__)) }
  subject { Dock.new(:project_path => project_path, :pattern => '*') }
  
  it "should discover all classes" do
    subject.classes.collect { |c| c.name.to_str }.should == %w( Person Girl Boy )
  end
  
  it "should attach only the relative filename" do
    subject.classes[0].file.should == "example.coffee"
  end
  
  it "should discover the correct instance methods" do
    subject.classes[0].instance_methods[1].name.should == "sayHello"
  end
  
  it "should discover the correct class methods" do
    subject.classes[0].class_methods[0].name.should == "getSpecies"
  end
  
  it "should create class level documentation" do
    subject.classes[0].documentation.length.should_not == 0
  end

	it "should discover params for methods that have them" do
		subject.classes[0].instance_methods[0].params.should_not be_empty
	end
	
	it "should populate each class with its language" do
		subject.classes.each { |k| k.language.should == 'coffee' }
	end
end

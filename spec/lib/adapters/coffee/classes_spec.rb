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
  
  it "should create params arrays for class methods" do
    subject.classes[0].class_methods[0].params.should be_kind_of(Array)
  end
end

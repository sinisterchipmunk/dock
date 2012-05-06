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
end

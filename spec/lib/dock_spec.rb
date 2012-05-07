require 'spec_helper'

describe Dock do
  it "should set default search path" do
    subject.project_path.to_s.length.should_not == 0
  end
  
  it "should set default pattern" do
    subject.pattern.to_s.length.should_not == 0
  end
  
  describe "run against itself" do
    subject { Dock.new(
      :pattern => 'dock.coffee', # ignore js because it's huge and takes much time
      :project_path => File.expand_path("../../lib/js", File.dirname(__FILE__)))
    }
    
    it "should find the Dock class" do
      subject.classes.collect { |c| c.name.to_str }.should include("Dock")
    end
  end
  
  describe "with overridden options" do
    subject { Dock.new(:project_path => "path", :pattern => "pattern") }
    
    it "should override path" do
      subject.project_path.should == "path"
    end

    it "should override pattern" do
      subject.pattern.should == "pattern"
    end
  end
end

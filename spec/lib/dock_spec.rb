require 'spec_helper'

describe Dock do
  it "should set default path" do
    subject.path.to_s.length.should_not == 0
  end
  
  it "should set default pattern" do
    subject.pattern.to_s.length.should_not == 0
  end
  
  describe "run against itself" do
    subject { Dock.new(
      :pattern => "**/*.{coffee,rb}", # ignore js because it's huge and takes much time
      :path => File.expand_path("lib", File.dirname(__FILE__))) }
    
    it "should find the Dock class" do
      subject.classes
    end
  end
  
  describe "with overridden options" do
    subject { Dock.new(:path => "path", :pattern => "pattern") }
    
    it "should override path" do
      subject.path.should == "path"
    end
    
    it "should override pattern" do
      subject.pattern.should == "pattern"
    end
  end
end

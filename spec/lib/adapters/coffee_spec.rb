require 'spec_helper'

describe "Coffee adapter" do
  it "should not croak on accessors" do
    proc { Dock.new(:code => '{}.x', :language => 'coffee').root_nodes }.should_not raise_error
  end
  
  it "should not croak on elses" do
    proc { Dock.new(:code => 'if 1 then 0 else 1', :language => 'coffee').root_nodes }.should_not raise_error
  end
  
  it "should not croak on whiles" do
    proc { Dock.new(:code => '1 while 0', :language => 'coffee').root_nodes }.should_not raise_error
  end
  
  it "should not croak on inverted ops" do
    proc { Dock.new(:code => '"" !instanceof String', :language => 'coffee').root_nodes }.should_not raise_error
  end
  
  it "should not croak in a file with only comments" do
    proc { Dock.new(:code => "# comment", :language => 'coffee').classes }.should_not raise_error
  end
  
  it "should discover exported classes" do
    d = Dock.new :code => "exports.Code = class Code\n  constructor: ->", :language => 'coffee'
    d.classes.first.name.should == 'Code'
  end
  
  it "should not croak on assigns to non-classes" do
    proc { Dock.new :code => "exports.Code = 1", :language => 'coffee' }.should_not raise_error
  end
end

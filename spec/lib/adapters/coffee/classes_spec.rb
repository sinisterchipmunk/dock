require 'spec_helper'

describe "Coffee adapter" do
  let(:path) { File.expand_path("../../../fixtures/coffee", File.dirname(__FILE__)) }
  subject { Dock.new(:path => path) }
  
  it "should discover all classes" do
    subject.classes.collect { |c| c.name }.should == %w(
      Brilliant
    )
  end
end

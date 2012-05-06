require 'action_view'

class Dock::Template < ActionView::Base
  attr_accessor :title, :node
  
  def initialize(options = {})
    super()
    options.each do |key, value|
      self.send :"#{key}=", value
    end
  end
end

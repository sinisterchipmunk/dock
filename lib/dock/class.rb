class Dock::Class
  def name
    @node['name']
  end
  
  def file
    @node['file']
  end
  
  def initialize(node)
    @node = node
  end
  
  def to_str
    name
  end
end

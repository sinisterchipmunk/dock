class Dock::Nodes::Value < Dock::Node
  def to_str
    literals[0].to_str
  end
end

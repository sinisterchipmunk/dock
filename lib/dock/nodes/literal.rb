class Dock::Nodes::Literal < Dock::Node
  def to_str
    value.to_s
  end
end

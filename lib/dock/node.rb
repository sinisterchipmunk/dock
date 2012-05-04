class Dock::Node
  class << self
    # Wraps the node hash in an instance of Dock::Node
    def wrap(hash)
      if hash['type']
        klass = Dock.const_get hash['type']
        klass ? klass.new(hash) : Dock::Node.new(hash)
      else
        raise "No node type for node #{hash.inspect}"
      end
    rescue NameError, TypeError
      Dock::Node.new hash
    end
  end
  
  def initialize(node)
    @node = node
    massage node
    node.each { |key, value| define_attribute key, value }
  end
  
  def to_str
    inspect
  end
  
  def inspect
    # Inspect the node hash, recursively removing empty arrays for legibility
    # FIXME why so ugly?

    prc = proc do |hash|
      hash = hash.dup
      hash.inject({}) do |new_hash, (key, value)|
        case value
          when Array
            new_value = []
            value.each do |entry|
              if entry.kind_of? Hash
                entry = prc.call entry
                new_value.push entry unless entry.empty?
              else
                new_value.push entry
              end
            end
            new_hash[key] = new_value unless new_value.empty?
          when Hash
            value = prc.call value
            new_hash[key] = value unless value.empty?
          else new_hash[key] = value
        end
        new_hash
      end
    end
  
    prc.call(@node).inspect
  end
  
  protected
  def eigenklass
    class << self
      self
    end
  end
  
  # If value is an array, it is massaged into an array of nodes.
  # If it is a hash, it is recursively massaged in a similar manner.
  # Otherwise it's returned untouched.
  def massage(value)
    # FIXME more ugliness
    
    if value.kind_of?(Array)
      value.collect! { |node| Dock::Node.wrap node }
    elsif value.kind_of?(Hash)
      massaged_values = value.inject({}) do |hash, (next_key, next_value)|
        next_value = massage next_value
        hash[next_key] = next_value unless next_value.empty?
        hash
      end
      value.clear
      value.merge! massaged_values
    end
    
    value
  end
  
  def define_attribute(name, value)
    eigenklass.send :define_method, name do
      value
    end
  end
end

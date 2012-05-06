class Dock::Node
  SAFE_METHODS = ['documentation'] # :nodoc:
  
  class << self
    alias_method :_new, :new # :nodoc:
    
    # Overridden to instantiate a subclass of Dock::Node if the
    # 'type' key of the given hash matches the demodulized name
    # of the subclass; returns a generic Dock::Node otherwise.
    #
    # Examples:
    #
    #     Dock::Node.new({'type' => 'Literal'}) #=> Dock::Node::Literal
    #     Dock::Node.new({})                    #=> Dock::Node
    #
    def new(hash)
      raise ArgumentError, "Expected a hash, got #{hash.inspect}" unless hash.kind_of?(Hash)
      if hash['type']
        if Dock::Nodes.constants.include?(hash['type'].to_sym)
          Dock::Nodes.const_get(hash['type'])._new(hash)
        else
          _new(hash)
        end
      else
        raise "No node type for node #{hash.inspect}"
      end
    end
  end
  
  def initialize(node)
    @node = node
    massage node
    node.each { |key, value| define_attribute key, value unless SAFE_METHODS.include?(key) }
  end
  
  def documentation                                                      
    @documentation ||= begin
      doc = @node['documentation']
      # doc may contain indentations left over from coffeescript parsing, so remove them
      white = nil
      doc.gsub(/\n[\s\t]+/) do |match|
        w = match.gsub(/\t/, '    ').length - 1
        white = w if white.nil? or w < white
      end
      doc.gsub!(/\n\s{#{white}}/, "\n")                 
      GitHub::Markup.render("file.#{Dock.markup}", doc).html_safe
    end
  end
  
  def to_str
    inspect
  end
  
  def to_s
    to_str
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
          when NilClass
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
      value.collect! do |node|
        if node.kind_of?(Hash)
          Dock::Node.new node
        else node
        end
      end
    elsif value.kind_of?(Hash)
      massaged_values = value.inject({}) do |hash, (next_key, next_value)|
        if next_value.kind_of?(Hash) and next_value.key?('type')
          next_value = Dock::Node.new next_value
        else
          next_value = massage next_value
        end
        
        hash[next_key] = next_value unless next_value.kind_of?(Hash) and next_value.empty?
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

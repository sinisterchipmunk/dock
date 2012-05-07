require 'action_view'

class Dock::Template < ActionView::Base
  attr_accessor :title, :node, :dock, :destination_root
  
  def initialize(options = {})
    super()
    options.each do |key, value|
      self.send :"#{key}=", value
    end
  end             

	def full_path
		File.expand_path node.file, destination_root
	end

	def path_to(file)
		link_path = File.expand_path file, destination_root        
		Pathname.new(link_path).relative_path_from(Pathname.new(File.dirname(full_path))).to_s
	end                             
	
	def method_signature(method)
		"#{method.name}(#{method_params method})" 
	end   
	
	def methods
		node.class_methods + node.instance_methods
	end        
	
	def image_link_to_method(method)
		if method.type == 'ClassMethod'
			type = "class_method"
		else
			if method.name == 'constructor'
				type = "constructor"
			else
				type = "instance_method"
			end
		end
		
		link_to image_tag(path_to("images/#{type}.png"), type.humanize), "#" + method_anchor(method)
	end
	
	def method_anchor(method)
		[method.type[0].downcase, method.name].join
	end   
	
	def image_tag(path, alt = nil)
		alt = "alt='#{alt}' title='#{alt}' " if alt
		"<img src='#{path}' #{alt}/>".html_safe
	end
	
	def method_params(method)
		method.params.collect { |parm| parm.default ? "#{parm.name} = #{parm.default}" : parm.name }.join(', ').html_safe
	end
end

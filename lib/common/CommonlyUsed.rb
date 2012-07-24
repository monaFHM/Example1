
require 'json'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'pry'

module CommonlyUsed


	def each_json_request(json_obj, request_params)
	
    #unless is generally used sparingly
		if request_params && json_obj

      #unless else is generally considered bad form
      #Also: Is there ever a Hash passed into this function?
      if json_obj.instance_of?(Hash)
				json_array=json_obj
      else
				json_array = JSON::parse(json_obj)			
      end

			request_params.each do |r|
				value= json_array[r]	
				yield value unless value.nil?				
			end
		end

	end

	def get_json_from_depth_request(json_obj, depth_request)
    
    #unless is generally used sparingly
		if json_obj && depth_request
			json_obj=JSON::parse(json_obj)

			depth_request.each do |item|
				if json_obj.instance_of?(Hash)
					json_obj = json_obj[item] if json_obj[item]
				elsif json_obj.instance_of?(Array)
          #modification of an array while iterating over it 
          #may lead to surprising results
          #in this case a recursive function call might be a better
          #alternative. Quickfix: dup 
          json_obj.dup.each do |hashitem|
						json_obj=hashitem[item] if hashitem[item]
					end
				end

			end
		end

		json_obj
	end

	def get_elements_from_XML(xmlString, xpath)
		doc = Nokogiri::XML(xmlString)
		
		doc.remove_namespaces!		
		doc.xpath(xpath).each do |node|
  			yield node
		end
	end

	def each_attribute_from_child_node_XML(xmlitem, xPatharray, attr_name)
    #In ruby these kind of protective barriers are in general
    #not done:
    #We have duck typing - this means that we could construct
    #an object that is NOT a String but could still be used by Nokogiri
    #(if Nokogiri itself does not check it that way). You can use
    #respond_to? if you want to check whether an object is "fit" and
    #supports the correct methods. 
		if xmlitem.instance_of?(String)
		 	doc = Nokogiri::XML(xmlitem)
		 else
			doc =xmlitem
		end

    #use literals if possible
		result= []

		if xPatharray
			xPatharray.each do |item|
				doc.xpath(item+"[@#{attr_name}]").each do |attrElement|

          #in general, push is not used if the << operator can be used.
          #It's more "visual".
					result << attrElement[attr_name]
				end
			end
		end

		result
	end

	def each_attribute_from_node_XML(xmlitem, attr_names)
    #same note about checking classes applies here.
		if xmlitem.instance_of?(String)
		 	doc = Nokogiri::XML(xmlitem)
		 else
			doc =xmlitem
		end

    #use literals if possible
		result= {}

		unless doc.nil?
			attr_names.each do |item|
				result[item] = doc.attr(item)
			end
		end
		result
	end

	def each_attribute_from_xpath(xmlString, element_name, attr_names)
		get_elements_from_XML(xmlString, element_name) do |item|
			yield each_attribute_from_node_XML(item, attr_names)
		end
	end

	def each_attribute_from_subsections(xmlString, subsection_xpath, xpathattrelements, attr_name) 

		get_elements_from_XML(xmlString, subsection_xpath) do |subsection|
			yield each_attribute_from_child_node_XML(subsection, xpathattrelements, attr_name)
		end
	end

	def get_text_from_node(node)
		return node.text
	end

	def encodeString(str)
		str.force_encoding("ISO-8859-1").encode("UTF-8")
	end

  #although you use an underscore here, the W needs to be a small one
  #('w')
	def request_Webservice(requestString)
    #unless is useful here since "" is not falsy.
		unless requestString.empty? 
			begin
				url = URI.escape(requestString)
				resp = Net::HTTP.get_response(URI.parse(url))
			rescue Exception
        #also: this only puts the class Exception, not the actual
        #instance of exception that was thrown.
				puts Exception
        #This is a clear antipattern. We should handle the exception
        #(i.e. modify the url and retry the whole thing maybe), 
        #pass on the Exception to where it will be handled (i.e. the
        #callee of request_Webservice) and/or throw custom ErrorTypes
        #with more information.
        #If you return nil, you make each developer of your libraries
        #guess why there is a nil value - nil does not have a stack
        #trace, an Exception does.
				nil
			end
		end 
	end

	def make_Uri_String_from_Hash(hash)
		first =true
		outputString=""

    if hash
		  	hash.each do |key,value|
				outputString +="&" unless first 
				outputString +="?" if first
				outputString +=key.to_s
				outputString +="="
				value=value.to_s
				value=value.split(/  */).join('+')
				outputString +=value

				first=false if first
			end	
	 	end
		outputString
	end

	def request_stub(const, paramsHash)
			result=nil
			requestURL = const + make_Uri_String_from_Hash(paramsHash)
			webserviceResponse=request_Webservice(requestURL)
			
			if webserviceResponse.code == "200"				
				encoded_result=encodeString(webserviceResponse.body)
				result = encoded_result
				result= yield encoded_result if block_given?
			else
				raise "Webservice Request unsuccesfully: " + webserviceResponse.body 
			end
			
			result
	end
	
end

require 'json'
require 'net/http'
require 'uri'
require 'pry'

module Helper
	class CommonlyUsed


		def each_json_request(json_obj, request_params)

			

			unless request_params.nil? || json_obj.nil?
				json_array = JSON::parse(json_obj)

				request_params.each do |r|
					value= json_array[r]
					#binding.pry				
					yield value unless value.nil?				
				end
			end

		rescue JSON::ParserError => e
			p e
		end

		def get_json_from_depth_request(json_obj, depth_request)
			
			unless json_obj.nil? || depth_request.nil?
				json_obj=JSON::parse(json_obj)

				depth_request.each do |item|
					if json_obj.instance_of?(Hash)
						json_obj = json_obj[item] if json_obj[item]
					elsif json_obj.instance_of?(Array)
						json_obj.each do |hashitem|
							json_obj=hashitem[item] if hashitem[item]
						end
					end

				end
			end

			json_obj
		end

		def request_Webservice(requestString)
			unless requestString.empty? 
				begin
					url = URI.escape(requestString)
					resp = Net::HTTP.get_response(URI.parse(url))
				rescue Exception
					puts Exception
					nil
				end
			end 
		end

		def make_Uri_String_from_Hash(hash)
			first =true
			#outputString=String.new
			outputString=""

			unless hash.nil?
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
		 	#binding.pry
			outputString
		end



	end
end
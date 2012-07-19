require_relative '../common/CommonlyUsed'

module Geocoding
	class GoogleGeoAPI

		def initialize()
			@helper = Helper::CommonlyUsed.new
			@GoogleRequestConst="http://maps.googleapis.com/maps/api/geocode/json"
		end


		def askForLngLat(requestParamString)

			requestString=@GoogleRequestConst+ @helper.make_Uri_String_from_Hash({'address' => requestParamString, 'sensor' => 'false'})
			webserviceResponse= @helper.request_Webservice(requestString)
			if webserviceResponse.code == "200"
				location=@helper.get_json_from_depth_request(webserviceResponse.body, ["results", "geometry", "location"])
			else
				raise "Webservice Request unsuccesfully"
			end
			
			#result[]
			#@helper.each_json_request(location, ["lat", "lng"]) do |item|
			#end
		end


	end
end
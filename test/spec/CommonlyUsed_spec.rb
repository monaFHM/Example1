 require_relative 'spec_helper'
 require 'pry'
 require 'nokogiri'


describe CommonlyUsed do

	before :each do
    	class TestHelper
    		include CommonlyUsed
    	end
    	@helper = TestHelper.new
    	@input = %{{ "name": "Micky", "surname": "Mouse", "girlfriend": "Minni Mouse" }}
	end
 
 	describe "#each_json_request" do


	    it "returns the params after parsing JSON to Hash" do
	    	input = %{{ "name": "Micky", "surname": "Mouse", "girlfriend": "Minni Mouse" }}
	    	request = ["name","surname"]
	    	result =[]
	        @helper.each_json_request(input,request) do |value|
	        	#binding.pry
	        	result.push(value)
	        end

	        result.should eql ["Micky", "Mouse"]
	    end

	     it "throws an exception by bad JSON" do
	     	input = %{ "name": "Micky", "surname": "Mouse", "girlfriend": "Minni Mouse" }
	    	request = ["name","surname"]
	    	result =[]
	        lambda {@helper.each_json_request(input, request)}.should raise_error
	    end
	end


	describe "xml stuff" do
		before :each do 
			@xml='<xml_api_reply version="1"><weather module_id="0" tab_id="0" mobile_row="0" mobile_zipped="1" row="0" section="0"><forecast_information><city data="Hamburg, Hamburg"/><postal_code data="Hamburg"/><latitude_e6 data=""/><longitude_e6 data=""/><forecast_date data="2012-07-20"/><current_date_time data="1970-01-01 00:00:00 +0000"/><unit_system data="SI"/></forecast_information><current_conditions><condition data="Regen"/><temp_f data="57"/><temp_c data="14"/><humidity data="Luftfeuchtigkeit: 88 %"/><icon data="/ig/images/weather/rain.gif"/><wind_condition data="Wind: W mit 26 km/h"/></current_conditions><forecast_conditions><day_of_week data="Fr."/><low data="8"/><high data="18"/><icon data="/ig/images/weather/chance_of_rain.gif"/><condition data="Vereinzelt Regen"/></forecast_conditions><forecast_conditions><day_of_week data="Sa."/><low data="9"/><high data="18"/><icon data="/ig/images/weather/chance_of_rain.gif"/><condition data="Vereinzelt Regen"/></forecast_conditions><forecast_conditions><day_of_week data="So."/><low data="11"/><high data="21"/><icon data="/ig/images/weather/chance_of_rain.gif"/><condition data="Vereinzelt Regen"/></forecast_conditions><forecast_conditions><day_of_week data="Mo."/><low data="13"/><high data="23"/><icon data="/ig/images/weather/mostly_sunny.gif"/><condition data="Meist sonnig"/></forecast_conditions></weather></xml_api_reply>'
		end

		describe "#get_elements_from_XML" do
			it "returns some valid nodes for valid xpath " do 
				@helper.get_elements_from_XML(@xml,"//weather/forecast_information/city") do |helper|
					result_str = helper["data"]
					result_str.should eql 'Hamburg, Hamburg'
				end				
			end

			it "raises an error for invalid xpath" do
				lambda {@helper.get_elements_from_XML(@xml, "/current_conditions/condition@data")}.should raise_error
			end

			it "doesnt yield anything if xpath isnt found" do
				result=[]
				@helper.get_elements_from_XML(@xml, "//surname") do |h|
					result << h
				end
				result.should eql []
			end

			it "doesn't yield anything for  invalid xml" do
				result=[]
				
				@helper.get_elements_from_XML("3dhuwi", "//weather") do |el|
					result << el
				end
					
				result.should eql []
			end

		end

		describe "#each_attribute_from_node_XML" do
			
			it "returns all attribute values for given attribut name in every node found by xpath info array, XML as String" do
				@helper.each_attribute_from_node_XML(@xml, ["//weather/forecast_information/city"], "data") do |a|
					a.should eql "Hamburg, Hamburg"
				end
			end

			it "returns all attribute values for given attribut name in every node found by xpath info array, XML as Doc" do
				xmldoc = Nokogiri::XML(@xml)
				@helper.each_attribute_from_node_XML(xmldoc, ["//weather/forecast_information/city"], "data") do |a|
					a.should eql "Hamburg, Hamburg"
				end
			end

			it "returns nil for bad xml, bad xpaths, bad attributename" do
				result=[]

				#bad xml
				@helper.each_attribute_from_node_XML('<"abc 234><d data="stuff"></d></abc>', ["//abc/d"], "data") do |a|
					result << a
				end

				#bad xpaths
				@helper.each_attribute_from_node_XML('<abc><d data="stuff"></d></abc>', ["//vbc/d"], "data") do |a|
					result << a
				end

				#bad attributname
				@helper.each_attribute_from_node_XML('<"abc 234><d data="stuff"></d></abc>', ["//abc/d"], "dta") do |a|
					result << a
				end
				result.should eql []
			end

		end
	end

	describe "#get_json_from_depth_request" do

		before :each do
			@depth_request=["results","geometry","location"]
	    	@input = %{{
   "results" : [
      {
         "address_components" : [
            {
               "long_name" : "1600",
               "short_name" : "1600",
               "types" : [ "street_number" ]
            },
            {
               "long_name" : "Amphitheatre Pkwy",
               "short_name" : "Amphitheatre Pkwy",
               "types" : [ "route" ]
            },
            {
               "long_name" : "Mountain View",
               "short_name" : "Mountain View",
               "types" : [ "locality", "political" ]
            },
            {
               "long_name" : "Santa Clara",
               "short_name" : "Santa Clara",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "California",
               "short_name" : "CA",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United States",
               "short_name" : "US",
               "types" : [ "country", "political" ]
            },
            {
               "long_name" : "94043",
               "short_name" : "94043",
               "types" : [ "postal_code" ]
            }
         ],
         "formatted_address" : "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",
         "geometry" : {
            "location" : {
               "lat" : 37.42291810,
               "lng" : -122.08542120
            },
            "location_type" : "ROOFTOP",
            "viewport" : {
               "northeast" : {
                  "lat" : 37.42426708029149,
                  "lng" : -122.0840722197085
               },
               "southwest" : {
                  "lat" : 37.42156911970850,
                  "lng" : -122.0867701802915
               }
            }
         },
         "types" : [ "street_address" ]
      }
   ],
   "status" : "OK"
}}
		end

		it "returns nil if json_obj is nil" do
			result=@helper.get_json_from_depth_request(nil,@depth_request)
			result.should eql nil
		end
		
		it "returns original json if depth_request is nil" do
			result=@helper.get_json_from_depth_request(@input,nil)
			result.should eql @input
		end

		it "returns json_obj from iterating trough depth request array" do
			result=@helper.get_json_from_depth_request(@input,@depth_request)
			result.should eql Hash['lat' => 37.42291810, 'lng' => (-122.08542120) ]
		end

	end

	describe "#request_Webservice" do
		
		it "returns nil if request URL is nil or bullshit" do
			request=""
			result=@helper.request_Webservice(request)
			result.should eql nil
		end

		it "returns nil if request URL is stupid" do
			request="htp:/www.google.de"
			result=@helper.request_Webservice(request)
			result.should eql nil
		end

		it "returns Webservice object HTTPOK when everything is fine" do
			request="http://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=true_or_false"
			result=@helper.request_Webservice(request)
			result.should be_an_instance_of Net::HTTPOK
		end

	end

	describe '#make_Uri_String_from_Hash' do
		
		it "returns String.empty when no hash is delivered" do
			hash=nil
			uriresult= @helper.make_Uri_String_from_Hash(hash)
			uriresult.should eql(String.new)
		end

		it "return a String from Hash seperated by &" do
			hash={'address' => '1600 Amphitheatre Parkway, Mountain View, CA', 'sensor' =>'true_or_false'}
			uri2result = @helper.make_Uri_String_from_Hash(hash)
			uri2result.should eql "?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=true_or_false"
		end
	end
end
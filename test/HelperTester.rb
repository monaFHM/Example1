 require_relative 'spec_helper'
 require 'pry'

describe Helper::CommonlyUsed do

	before :each do
    	@helper = Helper::CommonlyUsed.new
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
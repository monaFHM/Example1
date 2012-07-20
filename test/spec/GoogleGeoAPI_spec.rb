require_relative 'spec_helper'
require_relative "../../lib/Geocode/GoogleGeoAPI"

describe Geocoding::GoogleGeoAPI do

	before :each do
    	@google_geo = Geocoding::GoogleGeoAPI.new
	end
 
 	describe "#askForLngLat" do
 		it "writes value of  Lat and Lng in instance" do
 			@google_geo.askForLngLat('1600 Amphitheatre Parkway, Mountain View, CA')
 			@google_geo.lat.should eql 37.4231054
 			@google_geo.lng.should eql -122.0823988
 			#result.should eql ({"lat"=>, "lng"=>-122.0823988})
 		end
 		it "writes nil for values of lat and lng in instance when asking for bullshit" do
 			@google_geo.askForLngLat({:name => 'Micky', :surname => 'Mouse'})
 			@google_geo.lat.should eql nil
 			@google_geo.lng.should eql nil
 		end
 	end

 end
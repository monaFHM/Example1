require_relative 'spec_helper'

describe Geocoding::GoogleGeoAPI do

	before :each do
    	@google_geo = Geocoding::GoogleGeoAPI.new
	end
 
 	describe "#askForLngLat" do
 		it "gives back an Array with first Lat and then Lng" do
 			result = @google_geo.askForLngLat('1600 Amphitheatre Parkway, Mountain View, CA')
 			result.should eql ({"lat"=>37.4231054, "lng"=>-122.0823988})
 		end
 		it "gives back an empty array when asking for bullshit" do
 			result = @google_geo.askForLngLat({:name => 'Micky', :surname => 'Mouse'})
 			result.should eql []
 		end
 	end

 end
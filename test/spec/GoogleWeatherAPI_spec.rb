require_relative 'spec_helper'
require_relative "../../lib/Geocode/GoogleWeatherAPI"

describe Geocoding::GoogleWeatherAPI do

	before :each do
    	@google_geo = Geocoding::GoogleWeatherAPI.new
	end

	describe "#askForWeather(location)" do
		
		it "returns some Weather Info for Hamburg" do
			location="Hamburg"
			@google_geo.askForWeather(location)
			@google_geo.current_conditions.should_not eql nil
			@google_geo.forecast_conditions.should_not eql nil
		end

		it "doesn't return anything for bullshit input" do
			location='12378sdas'
			@google_geo.askForWeather(location)
			@google_geo.current_conditions.should eql []
			@google_geo.forecast_conditions.should eql []
		end

	end


end
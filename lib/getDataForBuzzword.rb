#!/usr/bin/env ruby

#require_relative("*.rb")
require_relative('Geocode/GoogleGeoAPI.rb')
require_relative('Geocode/GoogleWeatherAPI.rb')
require_relative('Social/YahooAnswerAPI.rb')
require_relative('Social/FlickrAPI.rb')

@buzzword=""

ARGV.each do|a|
  @buzzword += a
end

puts @buzzword


@googleGeo = Geocoding::GoogleGeoAPI.new
@googleWeater = Geocoding::GoogleWeatherAPI.new
@yahooAnswer =Social::YahooAnswerAPI.new
@flickr = Social::FlickrAPI.new

def printer(header, &block)
	puts ""
	puts header.upcase!
	puts "------------------------------------"
	block.call
	puts ""
end

@googleGeo.askForLngLat(@buzzword)
printer("GEO DATA") do
	puts "Lat: " + @googleGeo.lat.to_s
	puts "Lng: " + @googleGeo.lng.to_s
end


@googleWeater.askForWeather(@buzzword)
printer("WEATHER DATA") do
	puts "Current Conditions "
	p @googleWeater.current_conditions
	puts "Forecast "
	p @googleWeater.forecast_conditions
end


@yahooAnswer.askForQuestionsRealtedTo(@buzzword)
printer("Yahoo Answer Service") do
	p @yahooAnswer.list_of_questions
end

printer ("Flickr")do
 p @flickr.get_pictures_for(@buzzword)
end
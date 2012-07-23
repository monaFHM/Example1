require_relative 'spec_helper'
require_relative "../../lib/Social/FlickrAPI"

describe Social::FlickrAPI do

	before :each do 
		@flickr = Social::FlickrAPI.new
	end
	
	describe "#get_pictures_for(buzzword)"	do
		it "returns an array from img_tags" do
			img_tags = @flickr.get_pictures_for("Alpen")
			img_tags.length.should > 0
		end	

		# it "returns an empty array for bullhist" do
		# 	img_tags = @flickr.get_pictures_for("8392&/()")
		# 	img_tags.length.should eql 0 
		# end
	end


end
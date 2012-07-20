require_relative 'spec_helper'
require_relative "../../lib/Social/YahooAnswerAPI"

describe Social::YahooAnswerAPI do

	before :each do
    	@yahoo =  Social::YahooAnswerAPI.new
	end

	describe '#askForQuestionsRealtedTo(buzzword)' do 
		it "looks for some buzzword related anwers" do
			@yahoo.askForQuestionsRealtedTo("Liebe")
		end
	end
end
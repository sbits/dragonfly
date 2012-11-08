require 'spec_helper'

describe Dragonfly::WebP::Encoder do
  
  before(:all) do
    png_file = File.dirname(__FILE__) + '/../../../samples/beach.png' # 280x355, 135KB
    webp_file = File.dirname(__FILE__) + '/../../../samples/beach.webp' # 280x355, 135KB
    @png = Dragonfly::TempObject.new(File.new(png_file))
    @png.should have_size('135KB') ## just to be sure
    @webp = Dragonfly::TempObject.new(File.new(webp_file))
    @webp.should have_size('10.2KB') ## just to be sure
    @encoder = Dragonfly::WebP::Encoder.new
  end
  
  describe "#encode" do
    
    it "should encode the image to the correct format" do
      image = @encoder.encode(@png, :webp)
      image.should have_format('webp')
    end
    
    it "should throw :unable_to_handle if the format is not handleable" do
      lambda{
        @encoder.encode(@png, :goofy)
      }.should throw_symbol(:unable_to_handle)
    end
    
    it "should do nothing if the image is already in the correct format" do
      image = @encoder.encode(@webp, :webp)
      image.should == @webp
    end

    describe "should allow for extra args" do

	    it "should change the format" do
				image = @encoder.encode(@png, :webp, '-q 1')
				image.should have_format('webp')
			end

			it "should reduce the size of the jpeg image" do
				image = @encoder.encode(@png, :webp, '-q 1')
				image.should have_size('1.93KB')
			end

			it "should NOT work if the image is already in the correct format and args are given (WebP v0.2.1 cant handle this without an extra decode step first, yet)" do
				catch :unable_to_handle do
					image = @encoder.encode(@webp, :webp, '-q 1')
				end
			end
    end

  end
  
end

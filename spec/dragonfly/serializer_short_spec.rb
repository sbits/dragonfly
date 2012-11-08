# encoding: utf-8
require 'spec_helper'

describe Dragonfly::SerializerShort do
  
  #include Dragonfly::Serializer
  include Dragonfly::SerializerShort

  before(:each) do
	  ## TODO: create the needed profiles
	  @app = Dragonfly[:images]
	  @app.serializer = Dragonfly::SerializerShort
  end

  describe "marshal_encode" do
	  ## our (sbits) use cases are restricted to:
	  ## [[:f, :uid], [:p, :resize, :width], [:e, :format]]
	  ## which this serializer converts to
	  ## /:profile(p:resize)/:span(p:width)/:lock_version(self:lock_version)/:id(self:id).:format(e:format)
	  ## which means we shorten the urls
	  ## FROM /1/1/1/1.jpg
	  ## TO /99/99/123456789AB/BA987654321.jpg
	  ## whereas the images most surely wont ever get over +100.000, which would mean the maximum is at:
	  ## /media/99/99/123456/654321.jpg
	  ## compared to the default-dragonfly serializer urls:
	  ## /media/BAhbB1sHOgZmSSJTcC9pbWFnZXMvMDAwLzAwMC8wMTMvb3JpZ2luYWwvMDMtYXNlYWctZ2VzY2hhZWZ0c2JlcmljaHQtZGVzaWduLXdlc2VudGxpY2guanBnBjoGRVRbCDoGcDoLcmVzaXplSSIIOTQwBjsGRg/03-aseag-geschaeftsbericht-design-wesentlich.jpg?sha=e5e44e3f # as default
	  ## we should spare quite some bytes...
	  context "valid" do
			context ":phone" do
				it "x1 should return 1/1/1/1.jpg for '[[:f, '99/123.jpg'], [:p, :resize, 10], [:e, :jpg]]'" do
					marshal_encode([[:f, '99/123.jpg'], [:p, :resize, 10], [:e, :jpg]]).should == "1/1/99/123.jpg"
				end
				it "x1 should return 1/12/1/1.jpg for '[[:f, '99/123.jpg'], [:p, :resize, 120], [:e, :png]]'" do
					marshal_encode([[:f, '99/123.jpg'], [:p, :resize, 120], [:e, :png]]).should == "1/12/99/123.png"
				end
			end

			context ":phone_retina" do
				it "x1 should return 2/1 for (:phone_retina, 20)" do
					marshal_encode(['phone_retina', 20]).should == "2/1"
				end
				it "x1 should return 2/12 for (:phone_retina, 240)" do
					marshal_encode(['phone_retina', 240]).should == "2/12"
				end
			end
	  end


	  context "invalid" do
			it "should raise an error if the string passed in is empty" do
				lambda{
					marshal_encode('')
				}.should raise_error(Dragonfly::Serializer::BadString)
			end

			it "should raise an error if the string passed matches no configured profile" do
				lambda{
					marshal_encode('ahasdkjfhasdkfjh')
				}.should raise_error(Dragonfly::SerializerShort::InvalidProfile)
			end

			it "should raise an error if the string passed matches no configured profile/span" do
				lambda{
					marshal_encode(['phone', 99])
				}.should raise_error(Dragonfly::SerializerShort::InvalidProfileSpan)
			end
	  end

  end
  

  describe "marshal_decode" do
    it "should raise an error if the string passed in is empty" do
      lambda{
        marshal_decode('')
      }.should raise_error(Dragonfly::Serializer::BadString)
    end
    it "should raise an error if the string passed in is gobbledeegook" do
      lambda{
        marshal_decode('ahasdkjfhasdkfjh')
      }.should raise_error(Dragonfly::Serializer::BadString)
    end
  end

end

# encoding: utf-8
require 'base64'

module Dragonfly
  module SerializerShort

		include Dragonfly::Serializer

		class InvalidProfile < DragonflyError; end
		class InvalidProfileSpan < InvalidProfile; end

		extend self # So we can do Serializer.marshal_encode, etc.

    private

    def encode(data)
	    r = []
	    tmp = to_hash(data)
	    #puts "Got data: #{tmp.inspect}"

	    if tmp[:e]
	      format = tmp[:e].first.to_s if tmp[:e].first
	    end

	    if tmp[:f]
				parts = tmp[:f].first.split("/")
				file = parts.pop
		    r += parts
				filename = check_format(file, format)
	    end

	    if tmp[:p]
	      perform = tmp[:p]
				r << perform.last if perform && perform.size == 2
	    end

	    if tmp[:g]
		    gen = tmp[:g]
		    format2 = gen.pop if gen.last.is_a?(Hash)
		    r += gen
		    r << format2[:format] if format2 && format2[:format]
	    end

	    uid = r.compact.join("-")
	    if filename
	      uid << "/" << filename
	    end
	    #puts "Got uid: #{uid.inspect}"
	    uid
    end

    def decode(key)
	    ## we catch the image-rendering via config/routes.rb, so no need for a decoder
	    puts "we catch the image-rendering via config/routes.rb, so no need for a decoder"
	    raise "we catch the image-rendering via config/routes.rb, so no need for a decoder"
    end

	  def to_hash(data)
		  tmp = {}
		  data.each do |values|
			  tmp[ values.shift ] = values
		  end
		  tmp
	  end

	  def check_format(file, format = nil)
		  if !format.blank?
			  if !file.match(/#{format}$/)
				  suffix = file.split(".").pop
					return file.gsub(suffix, format)
				end
		  end
		  file
	  end
  end
end

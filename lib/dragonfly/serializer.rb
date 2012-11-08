# encoding: utf-8
require 'base64'

module Dragonfly
  module Serializer

    class BadString < RuntimeError; end

    extend self # So we can do Serializer.marshal_encode, etc.
    
    def marshal_encode(object)
	    raise BadString.new("Cannot encode an empty object") if object.blank?
	    #puts "Serializing object: #{object.inspect}"
      encode(object)
    end
    
    def marshal_decode(string)
      decode(string)
    rescue AbstractClassCalled
	    raise
    rescue TypeError, ArgumentError => e
      raise BadString, "#{self.class.name} couldn't decode #{string} - got #{e}"
    end

	  private

    def encode(string)
      raise AbstractClassCalled.new("Must call a subclass of #{self.class.name}.encode()")
    end

    def decode(string)
	    raise AbstractClassCalled.new("Must call a subclass of #{self.class.name}.decode()")
    end

  end
end

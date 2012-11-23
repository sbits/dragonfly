# encoding: utf-8
require 'base64'

module Dragonfly
  module SerializerDefault

		include Dragonfly::Serializer

    private

    def encode(string)
	    Base64.encode64(Marshal.dump(string)).tr("\n=",'').tr('/','~')
    end

    def decode(string)
	    padding_length = string.length % 4
	    Marshal.load(Base64.decode64(string.tr('~','/') + '=' * padding_length))
    end

  end
end

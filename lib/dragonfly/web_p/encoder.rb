module Dragonfly
  module WebP
    class Encoder

      include Configurable
      include Utils

      configurable_attr :supported_formats, [
        :webp
      ]

      def encode(temp_object, format, args='')
        format = format.to_s.downcase
        throw :unable_to_handle unless supported_formats.include?(format.to_sym)
        details = identify(temp_object)

        if details[:format] == format.to_sym
	        if args.empty?
            temp_object
	        else
		        ## TODO: cwebp cannot process webp images, need to decode first, then recode with new settings, which is not needed in my usecase
		        throw :unable_to_handle
					end
				else
					convert(temp_object, args, format)
				end
      end

    end
  end
end

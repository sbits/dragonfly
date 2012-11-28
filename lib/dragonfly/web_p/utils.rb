require 'tempfile'

module Dragonfly
  module WebP
    module Utils

      include Shell
      include Loggable
      include Configurable
      configurable_attr :convert_command, "cwebp"
      configurable_attr :identify_command, "identify"
    
      private

      def convert(temp_object=nil, args='', format=nil)
        tempfile = new_tempfile(format)
        tmp_object_path = quote(temp_object.path) if temp_object
        run convert_command, %(#{tmp_object_path} -quiet #{args} -o #{quote(tempfile.path)})
        tempfile
      end

      def identify(temp_object)
        # example of details string:
        # myimage.png PNG 200x100 200x100+0+0 8-bit DirectClass 31.2kb
	      ## myimage.webp WEBP 2350x1200 2350x1200+0+0 16-bit sRGB 154KB 0.060u 0:00.049
        format, width, height, depth = raw_identify(temp_object).scan(/([A-Z0-9]+) (\d+)x(\d+) .+ (\d+)-bit/)[0]
        {
          :format => format.downcase.to_sym,
          :width => width.to_i,
          :height => height.to_i,
          :depth => depth.to_i
        }
      end
    
      def raw_identify(temp_object, args='')
        run identify_command, "#{args} #{quote(temp_object.path)}"
      end
    
      def new_tempfile(ext=nil)
        tempfile = ext ? Tempfile.new(['dragonfly', ".#{ext}"]) : Tempfile.new('dragonfly')
        tempfile.binmode
        tempfile.close
        tempfile
      end

    end
  end
end

module Dragonfly
  module WebP
    class Encoder

      include Configurable
      include Utils

      configurable_attr :supported_formats, [
        :webp
      ]

			#  -h / -help  ............ short help
			#  -H / -longhelp  ........ long help
			#  -q <float> ............. quality factor (0:small..100:big)
			#  -alpha_q <int> ......... Transparency-compression quality (0..100).
			#  -preset <string> ....... Preset setting, one of:
			#                            default, photo, picture,
			#                            drawing, icon, text
			#     -preset must come first, as it overwrites other parameters.
			#  -m <int> ............... compression method (0=fast, 6=slowest)
			#  -segments <int> ........ number of segments to use (1..4)
			#  -size <int> ............ Target size (in bytes)
			#  -psnr <float> .......... Target PSNR (in dB. typically: 42)
			#
			#  -s <int> <int> ......... Input size (width x height) for YUV
			#  -sns <int> ............. Spatial Noise Shaping (0:off, 100:max)
			#  -f <int> ............... filter strength (0=off..100)
			#  -sharpness <int> ....... filter sharpness (0:most .. 7:least sharp)
			#  -strong ................ use strong filter instead of simple.
			#  -partition_limit <int> . limit quality to fit the 512k limit on
			#                           the first partition (0=no degradation ... 100=full)
			#  -pass <int> ............ analysis pass number (1..10)
			#  -crop <x> <y> <w> <h> .. crop picture with the given rectangle
			#  -resize <w> <h> ........ resize picture (after any cropping)
			#  -map <int> ............. print map of extra info.
			#  -print_psnr ............ prints averaged PSNR distortion.
			#  -print_ssim ............ prints averaged SSIM distortion.
			#  -print_lsim ............ prints local-similarity distortion.
			#  -d <file.pgm> .......... dump the compressed output (PGM file).
			#  -alpha_method <int> .... Transparency-compression method (0..1)
			#  -alpha_filter <string> . predictive filtering for alpha plane.
			#                           One of: none, fast (default) or best.
			#  -alpha_cleanup ......... Clean RGB values in transparent area.
			#  -noalpha ............... discard any transparency information.
			#  -lossless .............. Encode image losslessly.
			#  -hint <string> ......... Specify image characteristics hint.
			#                           One of: photo, picture or graph
			#
			#  -short ................. condense printed message
			#  -quiet ................. don't print anything.
			#  -version ............... print version number and exit.
			#  -noasm ................. disable all assembly optimizations.
			#  -v ..................... verbose, e.g. print encoding/decoding times
			#  -progress .............. report encoding progress
			#
			#Experimental Options:
			#  -af .................... auto-adjust filter strength.
			#  -pre <int> ............. pre-processing filter

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

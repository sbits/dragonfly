module Dragonfly
  module WebP

    # WebP Config is a saved configuration for Dragonfly apps, which does the following:
    # - registers a webp encoder
    # - adds 1 job shortcut to encode into webp (TODO: add decoder)
    # Look at the source code for apply_configuration to see exactly how it configures the app.
    module Config

      def self.apply_configuration(app, opts={})
        app.configure do |c|
          c.encoder.register(WebP::Encoder)

          c.job :webp do
            encode :webp
          end
        end
      end

    end
  end
end

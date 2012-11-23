require 'dragonfly'
require 'rails'

module Dragonfly
  class Railtie < ::Rails::Railtie

    initializer "dragonfly.railtie.initializer" do |app|
      app.middleware.insert_before 'ActionDispatch::Cookies', Dragonfly::CookieMonster
    end

    initializer "dragonfly.railtie.load_app_instance_data" do |app|
      Railtie.config do |config|
        config.app_root = app.root
      end
      app.class.configure do
        #Pull in all the migrations from Dragonfly to the application
        #config.paths['db/migrate'] += ['db/migrate']
        config.paths['db/migrate'] += config.paths["vendor/plugins"].existent
      end
    end

    #initializer "dragonfly.railtie.load_static_assets" do |app|
    #  app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    #end

  end
end

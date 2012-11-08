require "rubygems"
require "bundler/setup"
$:.unshift(File.expand_path('../lib', __FILE__))
require 'dragonfly'
include Dragonfly::Serializer
include Dragonfly::SerializerDefault
APP = Dragonfly[:images].configure_with(:imagemagick)

puts "Loaded stuff from dragonfly irbrc"
puts "\nAvailable sample images:\n"
puts Dir['samples/*']
puts "\nAvailable constants:\n"
puts "APP"
puts

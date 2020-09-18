require 'open-uri'
require 'nokogiri'
require 'pry'

require_relative "./lady_bird_johnson_wildflower/version"
require_relative "./cli.rb"
require_relative "./plant.rb"
require_relative "./scraper.rb"

module LadyBirdJohnsonWildflower
  class Error < StandardError; end
  # Your code goes here...
end

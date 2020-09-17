require 'nokogiri'
require 'open-uri'
require_relative "..lib/scraper.rb"
require_relative "..plant.rb"
require 'pry'

class
     CommandLineInterface

    def initialize
        # Insert Scraper methods probably
    end

    def self.run
        puts greeting = <<~OPENER.strip
            Welcome to the Truffle Oil app!
        OPENER
        
    end

    def self.get_list_of_states_from_scraper
        puts "----- Recommended Species By State -----"
        Scraper.list_of_states.each.with_index(1) { |d, i| puts "#{i}. #{d}" }  # => Starts index @ 1
    end

end
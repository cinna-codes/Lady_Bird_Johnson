require 'nokogiri'
require 'open-uri'
require_relative "..lib/scraper.rb"
require_relative "..plant.rb"
require 'pry'

class
     CommandLineInterface

    def initialize
        Scraper.get_all_states
        CLI.run
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

    def self.choose_from_search_page
        input = gets.strip
        index_number = input.to_i
        if index_number.between?(0, Scraper.last_search_page_scraped.length-1)
            Plant.all.find { |single_plant| single_plant.url == ('https://www.wildflower.org' + Scraper.last_search_page_scraped[index_number]) }
        end
    end
end
require 'nokogiri'
require 'open-uri'
require_relative "..lib/scraper.rb"
require_relative "..lib/plant.rb"
require 'pry'

class CommandLineInterface

    def initialize
        Scraper.get_all_states
        CommandLineInterface.call
    end

    def self.call
        input = ""
        puts greeting = <<~OPENER.strip
            Welcome! This project was made by a student of Flatiron's Software Engineering course. 
            You can use this app to search through the plant database collected by the Lady Bird Johnson Wildflower Center. You can visit them in your browser at: "https://www.wildflower.org/"
            If you would like to look at the recommended species by state, type "states" into the terminal.
            To search by a single plant, type "search" and then type your query on a new line.
            Typing "back" will take you back to this menu.
            Once you're finished with using the app, typing "exit" will end your session.
        OPENER
        until input.downcase = "exit"
            if input.downcase == "states"
                CommandLineInterface.get_list_of_states_from_scraper 
                CommandLineInterface.choose_from_list_of_states
            elsif input.downcase == "search"
                CommandLineInterface.search_by_common_name
                CommandLineInterface.choose_from_search_page
            end
        end
    end

    def self.get_list_of_states_from_scraper
        puts "----- Recommended Species By State -----"
        Scraper.list_of_states.each.with_index(1) { |d, i| puts "#{i}. #{d}" }  # => Starts index @ 1
    end

    def self.choose_from_list_of_states
        gets input.strip
        index_number = input.to_i - 1
        if index_number.between?(0, Scraper.list_of_states.length-1)
            search_this = 'https://www.wildflower.org/collections/' + Scraper.state_url_ends[index_number]
            Scraper.scrape_search_page(search_this)
        elsif input = "back"
            CommandLineInterface.call
        else
            puts "That input is invalid. Please select a number present on the list."
        end
    end

    def self.choose_from_search_page
        input = gets.strip
        index_number = input.to_i
        if index_number.between?(0, Scraper.last_search_page_scraped.length-1)
            plant_choice = Plant.all.find { |single_plant| single_plant.url == ('https://www.wildflower.org' + Scraper.last_search_page_scraped[index_number]) }
            puts "Scientific name: #{plant_choice.scientific_name} | Common name(s): #{plant_choice.common_names} | Family name: #{plant_choice.family_name}\n#{plant_choice.description}"
        elsif input = "back"
            CommandLineInterface.call
        else
            "That input is invalid. Please select a number present on the list."
        end
    end

    def self.search_by_common_name
        input = gets.strip
        if input.downcase == "back"
            CommandLineInterface.call
        else
            search_this = input.gsub(" ", "+")
            url = 'https://www.wildflower.org/plants/search.php?search_field=' + search_this + '&family=Acanthaceae&newsearch=true&demo='
            url
            Scraper.scrape_search_page(url)
        end
    end
end
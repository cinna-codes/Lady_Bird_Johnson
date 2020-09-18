# require 'nokogiri'
# require 'open-uri'
# require_relative "..lib/scraper.rb"
# require_relative "..lib/plant.rb"
# require 'pry'

class CLI

    def initialize
        Scraper.get_all_states
        CLI.call
    end

    def self.call
        input = ""
        until input.downcase == "exit"
        puts greeting = <<~OPENER.strip
            Welcome! This project was made by a student of Flatiron's Software Engineering course. 
            You can use this app to search through the plant database collected by the Lady Bird Johnson Wildflower Center. 
            You can visit them in your browser at: "https://www.wildflower.org/"
            If you would like to look at the recommended species by state, type "states" into the terminal.
            To search by a single plant, type "search" and then type your query on a new line.
            Once you're finished with using the app, typing "exit" will end your session.
        OPENER
        input = gets.strip
            if input.downcase == "states"
                CLI.get_list_of_states_from_scraper 
                CLI.choose_from_list_of_states
                CLI.display_results_of_search
                CLI.choose_from_search_page
            elsif input.downcase == "search"
                CLI.search_by_common_name
                # if Scraper.last_search_page_scraped != []
                #     CLI.display_results_of_search
                #     CLI.choose_from_search_page
                # end
            elsif input.downcase == "exit"
                puts "See you later! 🌻"
            else
                puts "Please enter a valid term."
            end
        end
    end

    def self.get_list_of_states_from_scraper
        puts "----- Recommended Species By State -----"
        Scraper.list_of_states.each.with_index(1) { |state, i| puts "#{i}. #{state}" }  # => Starts index @ 1
    end

    def self.choose_from_list_of_states
        puts "🌻 Type a number from the list above to see the recommended species by state."
        state_choice = gets.strip
        puts "🌻 Getting info—one moment please..."
        index_number = state_choice.to_i - 1
        search_this = ""
        if index_number.between?(0, Scraper.list_of_states.length-1)
            search_this = 'https://www.wildflower.org/collections/' + Scraper.state_url_ends[index_number]
            Scraper.scrape_search_page(search_this)
        else
            puts "🌻 That input is invalid. Please select a number present on the list."
        end
    end

    def self.display_results_of_search
        Scraper.last_search_page_scraped.each.with_index(1) do |scraped_url, i|  
            single_plant = Plant.all.find { |searched_plant| searched_plant.url == scraped_url }
        puts "#{i}. Scientific name: #{single_plant.scientific_name} | Common name(s): #{single_plant.common_names}"
        end
        if Scraper.last_search_page_scraped == []
            puts "🌻 Your search did not return any results. Please try again with a new plant."            
            puts "---------------------"
        end
    end

    def self.choose_from_search_page
        puts "🌻 Type a number from the list above to see more information about one of these species."
        puts '🌻 Alternatively, type "all" if you would like to see more information about every species listed.'
        input = gets.strip
        index_number = input.to_i - 1
        if input.downcase == "all"
            puts "---------------------"
            Scraper.last_search_page_scraped.each.with_index(1) do |scraped_url, i| 
            single_plant = Plant.all.find { |searched_plant| searched_plant.url == scraped_url }
            puts "#{i}. Scientific name: #{single_plant.scientific_name} | Common name(s): #{single_plant.common_names} | Family name: #{single_plant.family_name}\n\n🌻 #{single_plant.description}"
            puts "---------------------"
            end

        elsif index_number.between?(0, Scraper.last_search_page_scraped.length-1)
            single_plant = Plant.all.find { |searched_plant| searched_plant.url == Scraper.last_search_page_scraped[index_number] }
            puts "----- More Info -----"
            puts "Scientific name: #{single_plant.scientific_name} | Common name(s): #{single_plant.common_names} | Family name: #{single_plant.family_name}\n\n🌻 #{single_plant.description}"
            puts "---------------------"
        else
            puts "---------------------"
            puts "🌻 That input is invalid. Please select a number present on the list next time."
            puts "---------------------"
        end
    end

    def self.search_by_common_name
        puts "🌻 Please enter the name of the plant that you would like to find."
        puts "🌻 Common names are more likely to get you a list of species, while scientific names are more likely to show you the exact plant you're looking for."
        input = gets.strip
        puts "🌻 Getting info—one moment please..."
        search_this = ""
        if input.include?(" ")
            search_this = input.gsub(" ", "+")
        else
            search_this = input
        end
        url = 'https://www.wildflower.org/plants/search.php?search_field=' + search_this + '&family=Acanthaceae&newsearch=true&demo='
        #binding.pry
        if Scraper.single_plant?(url) == true
            # Return single plant info
            Scraper.retrieve_single_plant_info(url)
            single_plant = Plant.all.find { |searched_plant| searched_plant.url == url }
            puts "----- More Info -----"
            puts "Scientific name: #{single_plant.scientific_name} | Common name(s): #{single_plant.common_names} | Family name: #{single_plant.family_name}\n\n🌻 #{single_plant.description}"
            puts "---------------------"
        else
            Scraper.scrape_search_page(url)
            CLI.display_results_of_search
            CLI.choose_from_search_page if Scraper.last_search_page_scraped != []
        end
    end
end
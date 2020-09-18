require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
    # BASE_URL = 'https://www.wildflower.org'
    @@collections_url = 'https://www.wildflower.org/collections/'
    @@state_url_ends = []
    @@list_of_states = []
    @@last_search_page_scraped = []

    def self.get_all_states
        states = Nokogiri::HTML(open(@@collections_url))
        list_of_states_section = states.css(".section").first
        @@state_url_ends = list_of_states_section.css("a").map { |d| d.attribute("href").value }
        @@list_of_states = list_of_states_section.text.split(/ \|\n|\n/) # => splits by " |\n" and "\n"
        @@list_of_states.shift(2) # => Removes "" and "Recommended Species By State" from the beginning of the array
        @@list_of_states
    end

    def self.list_of_states
        @@list_of_states
    end

    def self.state_url_ends
        @@state_url_ends
    end

    def self.retrieve_single_plant_info(url)
        doc = Nokogiri::HTML(open(url))

        scientific_name = doc.css("h2 i").text
        tax_array = doc.css("h3").map { |line| line.text } #creates an array + places pure text into array
        common_names = tax_array[1]
        family_name = tax_array[2]
        description = ""

        p_tags = doc.css("p").map { |line| line.text }
        description_array = p_tags[1..2]
        # description_array.shift # Removes "Search for native plants by scientific name, common name or family. If you are not sure what you are looking for, try the Combination Search or our Recommended Species lists."
        # description_array.pop(5) # Removes ["View propagation protocol from Native Plants Network.", "Go back", "4801 La Crosse Ave.Austin, TX 78739512.232.0100MapContact Us", "\n", "\n" (and something else?)] 
            description = description_array.join("\n").strip # Make an `if` statement to account for []? Work on `.join` statement?
            new_plant_instantiation_array = [url, scientific_name, common_names, family_name, description]
            Plant.new(new_plant_instantiation_array) ### => Now you can send this off to Plant.new(Scraper.retrieve_single_plant_info(url))
        end

    def self.scrape_search_page(search_page_url)
        @@last_search_page_scraped = []
        doc = Nokogiri::HTML(open(search_page_url))
        if !doc.css("p").text.include?("Your search did not return any results, please try again.")
            partial_urls = doc.css("td a").map { |link| link.attribute("href").text } # .delete_prefix("..") if d.attribute("href").text.include?("plants") }.compact
            partial_urls_compacted = partial_urls.reject { |url_half| url_half.include?("gallery") }
            @@last_search_page_scraped = partial_urls_compacted.map { |url_half| url_half = ('https://www.wildflower.org/plants/' + url_half) }
            @@last_search_page_scraped.each do |url| # .with_index(1) do |url, i|
                new_plant = Scraper.retrieve_single_plant_info(url)
                # puts "#{i}. #{new_plant.scientific_name} - #{new_plant.common_names}"
            end
            # doc.css("i").map { |d| d.text } 
        else
            @@last_search_page_scraped = []
           puts "Your search did not return any results. Hit enter and please try again with a new plant."
        end
    end

    def self.last_search_page_scraped
        @@last_search_page_scraped
    end

    def self.single_plant?(url)
        doc = Nokogiri::HTML(open(url))
        check_this = doc.css("h2 i").text
        if check_this != ""
            true
        else
            false
        end
    end
end
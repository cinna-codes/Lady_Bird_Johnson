require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

    BASE_URL = 'https://www.wildflower.org'
    
    @@collections_url = 'https://www.wildflower.org/collections/'
    @@state_url_ends = []
    @@list_of_states = []


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

    def self.search_by_state
        gets input.strip
        index_number = input.to_i - 1
        if index_number.between?(0, @@list_of_states.length-1)
            @@collections_url + @@state_url_ends[index_number]
        else
            puts "That input is invalid. Please select a number present on the list."
        end
    end

    def self.retrieve_single_plant_info(url)
        doc = Nokogiri::HTML(open(url))

        scientific_name = doc.css("h2 i").text
        tax_array = doc.css("h3").map { |line| line.text } #creates an array + places pure text into array
        common_names = tax_array[1]
        family_name = tax_array[2]

        description_array = doc.css("p").map { |line| line.text }
        description_array.shift # Removes "Search for native plants by scientific name, common name or family. If you are not sure what you are looking for, try the Combination Search or our Recommended Species lists."
        description_array.pop(5) # Removes ["View propagation protocol from Native Plants Network.", "Go back", "4801 La Crosse Ave.Austin, TX 78739512.232.0100MapContact Us", "\n", "\n"] 
            if description_array != [""]
                description = description_array.join("\n") # Make an `if` statement to account for []? Work on `.join` statement?
            else
                description = "No description provided."
            end

            new_plant_instantiation_array = [scientific_name, common_names, family_name, description]
            new_plant_instantiation_array ### => Now you can send this off to Plant.new(Scraper.retrieve_single_plant_info(url))

            #####Move all above to Scraper class; Plant.new(assign data from the Scraper method)

            # all_sections = doc.css(".section").map { |d| d }  # => Grabs every section on the page & places them into an array
            # relevant_sections = all_sections[1..5] # => Grabs Plant Characteristics through Benefit
            # # => .map { |section| section.to_s } will turn each section into a string(DO NOT USE .TEXT BEFORE IT) and *CONVERTS TO ARRAY OF STRINGS*...from there you can .gsub your `<br>`s and things

            # array_to_split_by = ["\n", "<br>"]
            # array_of_things_to_remove_with_gsub = ["<h4>", '</h4>', '<strong>', '</strong>']

            # relevant_sections.map do |section|
            #     section = section.to_s
            #     section = section.gsub(Regexp.union(array_of_things_to_remove_with_gsub), "")
            #     section = section.split(Regexp.union(array_to_split_by))
            #     section.shift #=> gets rid of `<div style=\"float:left;width:97.3%;\" class=\"section\">"`
            #     section.pop(2) #=> gets rid of `"", "</div>"`
            #     section
            # end

            # # Maybe???
            # # # a_tags = sections[1].css("a").map { |d| d }  # => Grabs every anchor tag
            # # # @duration = a_tags[0].text # => Perennial
            # # # @habit = a_tags[1].text # => Subshrub
    end

    def self.search_by_common_name(input)
        input = input.gsub(" ", "+")
        search_this = 'https://www.wildflower.org/plants/search.php?search_field=' + input + '&family=Acanthaceae&newsearch=true&demo='
        search_this
    end

    def self.scrape_search_page(search_page_url)
        doc = Nokogiri::HTML(open(search_page_url))
        if !doc.css("p").text.include?("Your search did not return any results, please try again.")
            with_nils = doc.css("td a").map { |d| d.attribute("href").text.delete_prefix("..") if d.attribute("href").text.include?("plants") }
            no_nils = with_nils.compact
            no_nils.each.with_index(1) do |url_half, i|
                url = 'https://www.wildflower.org' + url_half
                new_plant = Plant.new(Scraper.retrieve_single_plant_info(url))
                puts "#{i}. #{new_plant.scientific_name} - #{new_plant.common_names}"
                #Puts new_plant and its attributes in a numbered list?????? Should there be a `.each.with_index(1)` ???
            end
            doc.css("i").map { |d| d.text } 
        else
           puts "Your search did not return any results, please try again."
        end
    end

end
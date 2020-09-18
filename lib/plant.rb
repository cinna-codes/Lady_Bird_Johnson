require 'nokogiri'
require 'open-uri'
require 'pry'

class Plant
    attr_reader :url, :scientific_name, :common_names, :family_name, :description

    @@all = []

    def initialize(plant_array)
        @url = plant_array[0]
        @scientific_name = plant_array[1] 
        @common_names = plant_array[2] 
        @family_name = plant_array[3] 
        @description = plant_array[4]

        @@all << self

    end

        def self.all
            @@all
        end
end

        # @scientific_name = doc.css("h2 i").text
        # @tax_array = doc.css("h3").map { |line| line.text } #creates an array + places pure text into array
        # @common_names = @tax_array[1]
        # @family_name = @tax_array[2]

        # description_array = doc.css("p").map { |line| line.text }
        # description_array.shift # Removes "Search for native plants by scientific name, common name or family. If you are not sure what you are looking for, try the Combination Search or our Recommended Species lists."
        # description_array.pop(5) # Removes ["View propagation protocol from Native Plants Network.", "Go back", "4801 La Crosse Ave.Austin, TX 78739512.232.0100MapContact Us", "\n", "\n"] 
        #     if description_array != [""]
        #         @description = description_array.join("\n") # Make an `if` statement to account for []? Work on `.join` statement?
        #     else
        #         @description = "No description provided."
        #     end
        #     #####Move all above to Scraper class; Plant.new(assign data from the Scraper method)

        #     all_sections = doc.css(".section").map { |d| d }  # => Grabs every section on the page & places them into an array
        #     relevant_sections = all_sections[1..5] # => Grabs Plant Characteristics through Benefit
        #     # => .map { |section| section.to_s } will turn each section into a string(DO NOT USE .TEXT BEFORE IT) and *CONVERTS TO ARRAY OF STRINGS*...from there you can .gsub your `<br>`s and things

        #     array_to_split_by = ["\n", "<br>"]
        #     array_of_things_to_remove_with_gsub = ["<h4>", '</h4>', '<strong>', '</strong>']

        #     relevant_sections.map do |section|
        #         section = section.to_s
        #         section = section.gsub(Regexp.union(array_of_things_to_remove_with_gsub), "")
        #         section = section.split(Regexp.union(array_to_split_by))
        #         section.shift #=> gets rid of `<div style=\"float:left;width:97.3%;\" class=\"section\">"`
        #         section.pop(2) #=> gets rid of `"", "</div>"`
        #         section
        #     end

        #     # Maybe???
        #     # # a_tags = sections[1].css("a").map { |d| d }  # => Grabs every anchor tag
        #     # # @duration = a_tags[0].text # => Perennial
        #     # # @habit = a_tags[1].text # => Subshrub
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
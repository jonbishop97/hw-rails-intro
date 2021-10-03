class Movie < ActiveRecord::Base
    def self.ratings
        @movies = Movie.all
        ratings_hash = Hash.new
        @movies.each do |movie|
            ratings_hash[movie.rating] = 1
        end
        return ratings_hash.keys.sort
    end
end
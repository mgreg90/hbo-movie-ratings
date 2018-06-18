# require ruby libraries
%w( json uri ).each { |lib| require lib }

# require gems
%w( httparty nokogiri ).each { |gem| require gem }

# require local files
local_files = %w(
  ./lib/ext/string
  ./lib/ext/object
  ./lib/ext/nil_class
  ./lib/time_range
  ./lib/movie
  ./lib/movie_collection
  ./lib/content_source/hbo
  ./lib/rating_source/rotten_tomatoes
)
local_files.each { |file| require_relative file }

class MovieRatingScript

  attr_reader :movies_source, :rating_source

  def self.run(movies_source, rating_source)
    new(movies_source, rating_source).run
  end

  def initialize(movies_source, rating_source)
    @movies_source = movies_source
    @rating_source = rating_source
  end

  def run
    puts "Fetching movies from HBO..."
    puts "#{movies.count} movies currently listed!"
    puts "Fetching ratings from Rotten Tomatoes..."
    rate(movies)

    movies.sort_by_tomato_rating.print_ratings
  end

  def movies
    @movies ||= movies_source.available_movies
  end

  def rate(movies)
    rating_source.rate(movies)
  end
end

MovieRatingScript.run(
  MovieRatingScript::ContentSource::Hbo,
  MovieRatingScript::RatingSource::RottenTomatoes
)
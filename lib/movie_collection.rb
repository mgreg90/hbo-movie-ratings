class MovieRatingScript
  class MovieCollection < Array

    def self.from_array(arr)
      movie_collection = new
      arr.each do |movie_hash|
        movie_collection << (movie_hash.is_a?(Movie) ? movie_hash : Movie.new(movie_hash))
      end
      movie_collection
    end

    def << movie
      deny_unless_movie(movie)
      super
    end

    def []= idx, movie
      deny_unless_movie(movie)
      super(idx, movie)
    end

    def sort_by_tomato_rating
      sort_by! { |movie| movie.rotten_tomatoes_rating || 0 }.reverse!
    end

    def sort_by_year
      sort_by! { |movie| movie.year || 0 }.reverse!
    end

    def print_ratings
      puts "=" * 50
      map(&:print_rating)
    end

    private

    def self.deny_unless_movie(movie)
      raise TypeError, "#{movie} is not a movie" unless movie.is_a? Movie
    end

    def deny_unless_movie(obj)
      self.class.deny_unless_movie(obj)
    end

  end
end
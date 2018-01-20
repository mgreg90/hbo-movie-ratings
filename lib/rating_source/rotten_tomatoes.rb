class MovieRatingScript
  module RatingSource
    class RottenTomatoes

      attr_reader :movies

      BASE_URL = "https://www.rottentomatoes.com/api/private/v2.0/search/?limit=2&q="

      def self.rate(movies)
        new(movies).rate
      end

      def initialize(movies)
        unless movies.is_a? MovieCollection
          raise TypeError, "#{movies} is not an instance of MovieCollection"
        end
        @movies = movies
      end

      def rate
        movies.
          map! { |movie| rate_one(movie) }
      end

      def rate_one(movie)
        search_results = fetch_rating_hash(movie)
        search_results = select_movie_by_year(search_results, movie)
        movie.update_from_rotten_tomatoes(search_results)
      end

      def fetch_rating_hash(movie)
        full_response = HTTParty.get("#{BASE_URL}#{URI.escape(movie.title)}")
        full_response.success? ? full_response.parsed_response['movies'] : []
      end

      private

      def select_movie_by_year(search_results, movie)
        return {} if search_results.empty?

        # find a base year to begin search
        initial_diff = search_results.find { |sr| sr['year'] }['year']

        # initialize current closest match
        closest = { idx: 0, diff: initial_diff }

        # loop thru 
        match = search_results.each_with_index do |rating_hash, idx|
          next if !rating_hash['year'] || !movie.year
          # short circuit if exact match
          return rating_hash if rating_hash['year'] == movie.year

          # find difference between years
          diff = (rating_hash['year'] - movie.year).abs

          # replace closest if difference is less than previous closest
          closest[:idx], closest[:diff] = idx, diff if diff < closest[:diff]
        end

        search_results[closest[:idx]]
      end

    end
  end
end
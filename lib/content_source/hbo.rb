class MovieRatingScript
  module ContentSource
    class Hbo

      AVAILABLE_MOVIES_URL = 'https://www.hbo.com/movies/catalog'.freeze

      def self.available_movies
        new.available_movies
      end

      def self.print_available_movies
        new.print_available_movies
      end

      def available_movies
        @movies ||= MovieCollection.from_array fetch_available_movies
      end

      def fetch_available_movies
        html_response = HTTParty.get(AVAILABLE_MOVIES_URL)
        JSON.parse(Nokogiri::HTML(html_response).css('.render.bandjson')[1]['data-band-json'])['data']['entries']
      end

      def print_available_movies
        print_movies available_movies
      end

      def print_movies(movies)
        puts JSON.pretty_generate movies
      end

    end
  end
end
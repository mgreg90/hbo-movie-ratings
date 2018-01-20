class MovieRatingScript
  class Movie

    attr_reader :title, :genres, :duration_minutes, :availability,
      :release_date, :cast, :rotten_tomatoes_rating

    HOURS_REGEX = /(?<hours>\d+)\sHR/i.freeze
    MINUTES_REGEX = /(?<mins>\d+)\sMIN/i.freeze

    def initialize(movie_hash)
      @title = movie_hash['title']
      @genres = movie_hash['genres']
      @duration_minutes = parse_duration(movie_hash['duration'])
      @availability = parse_availability(movie_hash['availability'])
      @release_date = parse_release_date(movie_hash['releaseDate'])
      @cast = []
    end
    
    def update_from_rotten_tomatoes(rating)
      @cast = cast_from_rotten_tomatoes(rating)
      @rotten_tomatoes_rating = rating['meterScore']
      self
    end

    def duration; duration_minutes; end

    def year
      release_date.try :year
    end

    def to_s
      "#{title} (#{year})"
    end

    def print_rating
      puts "#{self} starring #{cast(:string)} - #{rotten_tomatoes_rating || 'unrated'}"
    end

    def cast(format=:default)
      case format
      when :default
        @cast
      when :string
        @cast.join(', ')
      end
    end

    private

    def parse_duration(duration)
      hours = extract_value duration, HOURS_REGEX, :hours
      minutes =  extract_value duration, MINUTES_REGEX, :mins
      (hours || 0) * 60 + (minutes || 0)
    end

    def extract_value(string, regex, key)
      regex.match(string).try(:[], key).try(:to_i)
    end

    def parse_availability(availabilities)
      TimeRange.from_hash(availabilities.first) if availabilities.any?
    end

    def parse_release_date(release_date)
      Date.parse(release_date) if release_date
    end

    def cast_from_rotten_tomatoes(rating)
      (rating['castItems'] || []).map { |actor| actor['name'] }
    end

  end
end
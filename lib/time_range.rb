class MovieRatingScript
  class TimeRange

    attr_reader :start_time, :end_time

    def self.from_hash(hash)
      new(hash['start'] || hash['start_time'], hash['end'] || hash['end_time'])
    end

    def initialize(start_time, end_time)
      @start_time = parse(start_time)
      @end_time = parse(end_time)
      unless end_time >= start_time
        raise ArgumentError, "end time must be after start time"
      end
    end

    def to_s
      "#{@start_time} .. #{@end_time}"
    end

    def length
      @end_time - @start_time
    end

    private

    def parse(time)
      return time.to_time.localtime if time.respond_to? :to_time
      Time.parse(time).localtime
    end

  end
end
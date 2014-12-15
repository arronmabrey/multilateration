module Multilateration
  class SignalEvent
    include Comparable

    attr_reader :coordinate, :time
    private :coordinate, :time

    def initialize(coordinate:, time:)
      @coordinate = coordinate
      @time       = time
    end

    def to_h
      {coordinate: coordinate, time:  time}
    end

    def <=>(other)
      time_of_arrival <=> other.time_of_arrival
    end

    def -(other)
      vector - other.vector
    end

    def inner_product_sq
      vector.inner_product(vector)
    end

    def time_difference_of_arrival(other)
      time_of_arrival - other.time_of_arrival
    end

    def time_of_arrival
      time
    end

    def distance_between(coordinate)
      Math.sqrt((vector - Vector.elements(coordinate)).map { |component| component.abs**2 }.reduce(&:+))
    end

    protected def vector
      @vector ||= Vector.elements(coordinate)
    end

  end
end

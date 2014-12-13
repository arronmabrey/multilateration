module Multilateration
  class SignalEventsGenerator

    TIMESTAMP_FORMAT = "%Y-%m-%dT%H:%M:%S.%N%z"

    def self.generate
      new(
        receiver_count: 5,
        coordinate_num_dimensions: 3,
        coordinate_max_area: 1000,
        coordinate_max_precision: 4,
        signal_propagation_max_speed: 500,
        signal_propagation_max_precision: 4,
      ).generate
    end

    attr_reader :receiver_count, :coordinate_num_dimensions, :coordinate_max_area, :coordinate_max_precision, :signal_propagation_max_speed, :signal_propagation_max_precision
    private :receiver_count, :coordinate_num_dimensions, :coordinate_max_area, :coordinate_max_precision, :signal_propagation_max_speed, :signal_propagation_max_precision

    def initialize(receiver_count:, coordinate_num_dimensions:, coordinate_max_area:, coordinate_max_precision:, signal_propagation_max_speed:, signal_propagation_max_precision:)
      @receiver_count                   = receiver_count
      @coordinate_num_dimensions        = coordinate_num_dimensions
      @coordinate_max_area              = coordinate_max_area
      @coordinate_max_precision         = coordinate_max_precision
      @signal_propagation_max_speed     = signal_propagation_max_speed
      @signal_propagation_max_precision = signal_propagation_max_precision
    end

    def generate(rc: receiver_count)
      signal_events = []

      emission_timestamp   = random_high_resolution_timestamp
      emitter_coordinate   = random_coordinate
      receiver_coordinates = rc.times.map { random_coordinate }

      signal_events << signal_event_for(:emitter, emitter_coordinate, emission_timestamp)

      receiver_coordinates.each do |coordinate|
        signal_events << signal_event_for(:receiver, coordinate, propagation_timestamp(emission_timestamp, emitter_coordinate, coordinate))
      end

      signal_events
    end

    private

    def signal_event_for(type, coordinate, time)
      {type: type, coordinate: coordinate, time: time}
    end

    def propagation_timestamp(emission_timestamp, emitter_coordinate, coordinate)
      propagation_duration = distance_between_coordinates(emitter_coordinate, coordinate) / random_signal_propagation_speed
      propagation_time     = timestamp_to_time(emission_timestamp) - propagation_duration
      time_to_timestamp(propagation_time)
    end

    def distance_between_coordinates(coordinate1, coordinate2)
      vector1 = coordinate_to_vector(coordinate1)
      vector2 = coordinate_to_vector(coordinate2)
      Math.sqrt((vector1 - vector2).map { |component| component.abs**2 }.reduce(&:+))
    end

    def random_signal_propagation_speed(spms: signal_propagation_max_speed, spmp: signal_propagation_max_precision)
      Rantly { range(1, spms) + float.round(range(0, spmp)) }
    end

    def random_high_resolution_timestamp
      time_to_timestamp Time.at(Rantly { integer(1_000_000_000) + float })
    end

    def random_coordinate(cnd: coordinate_num_dimensions, cma: coordinate_max_area, cmp: coordinate_max_precision)
      Rantly(cnd) { range(-cma, cma) + float.round(range(0, cmp)) }
    end

    def coordinate_to_vector(coordinate)
      Vector.elements(coordinate)
    end

    def time_to_timestamp(time)
      time.utc.strftime(TIMESTAMP_FORMAT)
    end

    def timestamp_to_time(timestamp)
      Time.parse(timestamp).utc
    end
  end
end

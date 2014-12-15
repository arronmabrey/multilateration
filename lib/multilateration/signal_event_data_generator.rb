module Multilateration
  class SignalEventDataGenerator

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
      signal_propagation_speed = random_signal_propagation_speed
      emission_timestamp       = random_high_resolution_timestamp
      emitter_coordinate       = random_coordinate
      receiver_coordinates     = rc.times.map { random_coordinate }

      {
        signal_propagation_speed: signal_propagation_speed,
        emitter_event: signal_event_for(emitter_coordinate, emission_timestamp),
        receiver_events: receiver_coordinates.map { |coordinate|
          signal_event_for(coordinate, propagation_timestamp(signal_propagation_speed, emission_timestamp, emitter_coordinate, coordinate))
        },
      }
    end

    private

    def signal_event_for(coordinate, timestamp)
      {coordinate: coordinate, time: timestamp}
    end

    def propagation_timestamp(signal_propagation_speed, emission_timestamp, emitter_coordinate, coordinate)
      propagation_duration = distance_between_coordinates(emitter_coordinate, coordinate) / signal_propagation_speed
      propagation_time     = emission_timestamp - propagation_duration
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
      Time.at(Rantly { integer(1_000_000_000) + float })
    end

    def random_coordinate(cnd: coordinate_num_dimensions, cma: coordinate_max_area, cmp: coordinate_max_precision)
      Rantly(cnd) { range(-cma, cma) + float.round(range(0, cmp)) }
    end

    def coordinate_to_vector(coordinate)
      Vector.elements(coordinate)
    end

  end
end

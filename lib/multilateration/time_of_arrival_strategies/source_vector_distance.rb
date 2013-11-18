module Multilateration
  module TimeOfArrivalStrategies
    class SourceVectorDistance
      attr_reader :source_vector, :wave_speed
      private :source_vector

      def initialize(source_vector, wave_speed=1)
        @source_vector = source_vector
        @wave_speed    = wave_speed
      end

      def tdoa(vector_a, vector_b)
        toa(vector_a) - toa(vector_b)
      end

      def toa(target_vector)
        distance_between_source_vector_and(target_vector) / wave_speed
      end

      private

      def distance_between_source_vector_and(target_vector)
        Math.sqrt((target_vector - source_vector).map { |component| component.abs**2 }.reduce(&:+))
      end
    end
  end
end

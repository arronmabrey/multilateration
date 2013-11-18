module Multilateration
  class Solver
    attr_reader :unsorted_receivers, :wave_speed
    private :unsorted_receivers, :wave_speed

    def initialize(unsorted_receivers, wave_speed)
      @unsorted_receivers = unsorted_receivers
      @wave_speed = wave_speed
    end

    def solved_emitter
      Emitter.new(Vector[*(middle_receivers_ai_matrix * middle_receivers_bi_matrix).flat_map])
    end

    private

    def middle_receivers_ai_matrix
      Matrix.rows(middle_receivers.map { |i| ai(i) }).inverse
    end

    def middle_receivers_bi_matrix
      Matrix.columns([middle_receivers.map { |i| bi(i) }])
    end

    def middle_receivers
      receivers[1..-2]
    end

    def receivers
      unsorted_receivers.sort_by(&:time_unit_of_arrival)
    end

    def last_receiver
      receivers.last
    end

    def first_receiver
      receivers.first
    end

    def tdoa_between_receivers_first_and_last
      tdoa_between_receivers_first_and(last_receiver)
    end

    def tdoa_between_receivers_first_and(other_receiver)
      other_receiver.time_unit_of_arrival - first_receiver.time_unit_of_arrival
    end

    def ai(i)
      2*( (v(tdoa_between_receivers_first_and_last)*(i.vector - first_receiver.vector))-(v(tdoa_between_receivers_first_and(i))*(last_receiver.vector - first_receiver.vector)) )
    end

    def v(time, exp=1)
      (wave_speed**exp) * (time**exp)
    end

    def bi(i)
      (v(tdoa_between_receivers_first_and(i))*(v2(tdoa_between_receivers_first_and_last)-inner_product_sq(last_receiver))) + ((v(tdoa_between_receivers_first_and(i))-v(tdoa_between_receivers_first_and_last))*inner_product_sq(first_receiver)) + (v(tdoa_between_receivers_first_and_last)*(inner_product_sq(i)-v2(tdoa_between_receivers_first_and(i))))
    end

    def v2(time)
      v(time, 2)
    end

    def inner_product_sq(receiver)
      receiver.vector.inner_product(receiver.vector)
    end

  end
end

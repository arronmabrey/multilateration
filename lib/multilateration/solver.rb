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

    def ai(i)
      2*( (v(t(last_receiver)-t(first_receiver))*(p(i)-p(first_receiver)))-(v(t(i)-t(first_receiver))*(p(last_receiver)-p(first_receiver))) )
    end

    def t(receiver)
      receiver.time_unit_of_arrival
    end

    def v(time, exp=1)
      (wave_speed**exp) * (time**exp)
    end

    def bi(i)
      (v(t(i)-t(first_receiver))*(v2(t(last_receiver)-t(first_receiver))-tp(last_receiver))) + ((v(t(i)-t(first_receiver))-v(t(last_receiver)-t(first_receiver)))*tp(first_receiver)) + (v(t(last_receiver)-t(first_receiver))*(tp(i)-v2(t(i)-t(first_receiver))))
    end

    def v2(time)
      v(time, 2)
    end

    def p(receiver)
      receiver.vector
    end

    def tp(receiver)
      p(receiver).inner_product(p(receiver))
    end

  end
end

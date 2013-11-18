module Multilateration
  class Solver
    attr_reader :unsorted_receivers, :wave_speed
    private :unsorted_receivers, :wave_speed

    def initialize(unsorted_receivers, wave_speed)
      @unsorted_receivers = unsorted_receivers
      @wave_speed = wave_speed
    end

    def solved_emitter
      Emitter.new(Vector[*(middle_receivers_aic_matrix * middle_receivers_bic_matrix).flat_map])
    end

    private

    def middle_receivers_aic_matrix
      Matrix.rows(middle_receivers.map { |i| aic(i, c) }).inverse
    end

    def middle_receivers_bic_matrix
      Matrix.columns([middle_receivers.map { |i| bic(i, c) }])
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

    def c
      first_receiver
    end

    def first_receiver
      receivers.first
    end

    def aic(i, c)
      2*( (v(t(last_receiver)-t(c))*(p(i)-p(c)))-(v(t(i)-t(c))*(p(last_receiver)-p(c))) )
    end

    def t(receiver)
      receiver.time_unit_of_arrival
    end

    def v(time, exp=1)
      (wave_speed**exp) * (time**exp)
    end

    def bic(i, c)
      (v(t(i)-t(c))*(v2(t(last_receiver)-t(c))-tp(last_receiver))) + ((v(t(i)-t(c))-v(t(last_receiver)-t(c)))*tp(c)) + (v(t(last_receiver)-t(c))*(tp(i)-v2(t(i)-t(c))))
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

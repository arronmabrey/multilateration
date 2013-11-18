module Multilateration
  class Solver
    attr_reader :unsorted_receivers, :wave_speed
    private :unsorted_receivers, :wave_speed

    def initialize(unsorted_receivers, wave_speed)
      @unsorted_receivers = unsorted_receivers
      @wave_speed = wave_speed
    end

    def solved_emitter
      Emitter.new(Vector[*(middle_receivers_aijc_matrix * middle_receivers_bijc_matrix).flat_map])
    end

    private

    def middle_receivers_aijc_matrix
      Matrix.rows(middle_receivers.map { |i| aijc(i, j, c) }).inverse
    end

    def middle_receivers_bijc_matrix
      Matrix.columns([middle_receivers.map { |i| bijc(i, j, c) }])
    end

    def middle_receivers
      receivers[1..-2]
    end

    def receivers
      unsorted_receivers.sort_by(&:time_unit_of_arrival)
    end

    def j
      last_receiver
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

    def aijc(i, j, c)
      2*( (v(t(j)-t(c))*(p(i)-p(c)))-(v(t(i)-t(c))*(p(j)-p(c))) )
    end

    def t(receiver)
      receiver.time_unit_of_arrival
    end

    def v(time, exp=1)
      (wave_speed**exp) * (time**exp)
    end

    def bijc(i, j, c)
      (v(t(i)-t(c))*(v2(t(j)-t(c))-tp(j))) + ((v(t(i)-t(c))-v(t(j)-t(c)))*tp(c)) + (v(t(j)-t(c))*(tp(i)-v2(t(i)-t(c))))
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

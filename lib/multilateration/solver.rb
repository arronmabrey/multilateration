module Multilateration
  class Solver
    attr_reader :receivers, :wave_speed, :time_of_arrival_strategy
    private :receivers, :wave_speed, :time_of_arrival_strategy

    def initialize(unsorted_receivers, time_of_arrival_strategy)
      @receivers  = unsorted_receivers.sort_by { |r| time_of_arrival_strategy.toa(r) }
      @wave_speed = time_of_arrival_strategy.wave_speed
      @time_of_arrival_strategy = time_of_arrival_strategy
    end

    def solved_vector
      Vector.elements (ai_matrix * bi_matrix).flat_map.to_a
    end

    private

    def ai_matrix
      Matrix.rows(middle_receivers.map { |i| ai(i) }).inverse
    end

    def bi_matrix
      Matrix.columns([middle_receivers.map { |i| bi(i) }])
    end

    def ai(i)
      2*(   ( distance(tdoa_between_receivers_first_and_last) * ( i             - first_receiver )) \
          - ( distance(tdoa_between_receivers_first_and(i))   * ( last_receiver - first_receiver )) )
    end

    def bi(i)
        ( distance(tdoa_between_receivers_first_and(i))   * ( distance_sq(tdoa_between_receivers_first_and_last) - inner_product_sq(last_receiver)                  )) \
      + ( inner_product_sq(first_receiver)                * ( distance(tdoa_between_receivers_first_and(i))      - distance(tdoa_between_receivers_first_and_last)  )) \
      + ( distance(tdoa_between_receivers_first_and_last) * ( inner_product_sq(i)                                - distance_sq(tdoa_between_receivers_first_and(i)) ))
    end

    def middle_receivers
      receivers - [first_receiver, last_receiver]
    end

    def first_receiver
      receivers.first
    end

    def last_receiver
      receivers.last
    end

    def tdoa_between_receivers_first_and_last
      tdoa_between_receivers_first_and(last_receiver)
    end

    def tdoa_between_receivers_first_and(other_receiver)
      time_of_arrival_strategy.tdoa(other_receiver, first_receiver)
    end

    def distance(time, exp=1)
      (wave_speed**exp) * (time**exp)
    end

    def distance_sq(time)
      distance(time, 2)
    end

    def inner_product_sq(vector)
      vector.inner_product(vector)
    end

  end
end

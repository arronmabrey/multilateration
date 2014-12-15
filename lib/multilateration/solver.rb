module Multilateration
  class Solver
    attr_reader :receivers, :signal_propagation_speed
    private :receivers, :signal_propagation_speed

    def initialize(receiver_events:, signal_propagation_speed:)
      @receivers  = receiver_events.map {|e| SignalEvent.new(e) }.sort
      @signal_propagation_speed = signal_propagation_speed
    end

    def solved_signal_event_emitter
      time_between = first_receiver.distance_between(solved_coordinate) / signal_propagation_speed
      solved_time  = (first_receiver.time_of_arrival + time_between)
      SignalEvent.new(coordinate: solved_coordinate, time: solved_time).to_h
    end

    private

    def solved_coordinate
      (ai_matrix * bi_matrix).flat_map.to_a
    end

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
        ( distance(tdoa_between_receivers_first_and(i))   * ( distance_sq(tdoa_between_receivers_first_and_last) - last_receiver.inner_product_sq                   )) \
      + ( first_receiver.inner_product_sq                 * ( distance(tdoa_between_receivers_first_and(i))      - distance(tdoa_between_receivers_first_and_last)  )) \
      + ( distance(tdoa_between_receivers_first_and_last) * ( i.inner_product_sq                                 - distance_sq(tdoa_between_receivers_first_and(i)) ))
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
      first_receiver.time_difference_of_arrival(other_receiver)
    end

    def distance(time, exp=1)
      (signal_propagation_speed**exp) * (time**exp)
    end

    def distance_sq(time)
      distance(time, 2)
    end

  end
end

module Multilateration
  class Receiver
    attr_reader :vector, :time_unit_of_arrival_strategy
    private :time_unit_of_arrival_strategy

    def initialize(vector, time_unit_of_arrival_strategy)
      @vector = vector
      @time_unit_of_arrival_strategy = time_unit_of_arrival_strategy
    end

    def time_unit_of_arrival
      time_unit_of_arrival_strategy.calculate(self)
    end
  end
end

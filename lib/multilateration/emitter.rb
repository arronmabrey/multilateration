module Multilateration
  class Emitter
    attr_reader :vector
    extend Forwardable
    def_delegators :@vector, :magnitude

    def initialize(vector)
      @vector = vector
    end
  end
end

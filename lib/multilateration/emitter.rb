module Multilateration
  class Emitter
    extend Forwardable
    def_delegators :@vector, :magnitude

    def initialize(vector)
      @vector = vector
    end
  end
end

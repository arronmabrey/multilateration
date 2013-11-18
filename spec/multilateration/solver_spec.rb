require 'spec_helper'

class TimeOfArrivalStrategy
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

describe Multilateration::Solver do
  describe "#solved_vector" do
    let(:source_vector)    { Vector[-20,5,120.2]   }
    let(:reciver_vector_0) { Vector[0,25,1]        }
    let(:reciver_vector_1) { Vector[50,20.34,2]    }
    let(:reciver_vector_2) { Vector[50,50,33]      }
    let(:reciver_vector_3) { Vector[23,75,4]       }
    let(:reciver_vector_4) { Vector[100,-100,-5.5] }
    let(:time_of_arrival_strategy) { TimeOfArrivalStrategy.new(source_vector) }
    let(:recivers) { [reciver_vector_0, reciver_vector_1, reciver_vector_2, reciver_vector_3, reciver_vector_4] }

    subject(:solved_vector) { described_class.new(recivers, time_of_arrival_strategy).solved_vector }

    specify { expect( solved_vector.magnitude ).to be_within(0.0000000000001).of(source_vector.magnitude) }
  end
end

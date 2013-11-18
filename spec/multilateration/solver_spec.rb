require 'spec_helper'

describe Multilateration::Solver do
  describe "#solved_vector" do
    let(:source_vector)    { Vector[-20,5,120.2]   }
    let(:reciver_vector_0) { Vector[0,25,1]        }
    let(:reciver_vector_1) { Vector[50,20.34,2]    }
    let(:reciver_vector_2) { Vector[50,50,33]      }
    let(:reciver_vector_3) { Vector[23,75,4]       }
    let(:reciver_vector_4) { Vector[100,-100,-5.5] }
    let(:time_of_arrival_strategy) { Multilateration::TimeOfArrivalStrategies::SourceVectorDistance.new(source_vector) }
    let(:recivers) { [reciver_vector_0, reciver_vector_1, reciver_vector_2, reciver_vector_3, reciver_vector_4] }

    subject(:solved_vector) { described_class.new(recivers, time_of_arrival_strategy).solved_vector }

    specify { expect( solved_vector.magnitude ).to be_within(0.0000000000001).of(source_vector.magnitude) }
  end
end

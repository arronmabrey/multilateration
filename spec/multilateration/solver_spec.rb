require 'spec_helper'

class MockTimeOfArrivalStrategy < Struct.new(:origin_emitter, :wave_speed)
  attr_accessor :receiver
  def calculate(receiver)
    self.receiver = receiver
    wave_travel_time_between_origin_emitter_and_receiver
  end

  private

  def wave_travel_time_between_origin_emitter_and_receiver
    distance_between_origin_emitter_and_receiver / wave_speed
  end

  def distance_between_origin_emitter_and_receiver
    Math.sqrt((receiver.vector - origin_emitter.vector).map { |component| component.abs**2 }.reduce(&:+))
  end
end

describe Multilateration::Solver do
  describe "#solved_emitter" do
    let(:wave_speed) { 1 }
    let(:seeded_emitter) { Multilateration::Emitter.new(Vector[-20,5,120.2]) }
    let(:time_unit_of_arrival_strategy) { MockTimeOfArrivalStrategy.new(seeded_emitter, wave_speed) }
    let(:reciver_0) { Multilateration::Receiver.new(Vector[0,25,1],        time_unit_of_arrival_strategy) }
    let(:reciver_1) { Multilateration::Receiver.new(Vector[50,20.34,2],    time_unit_of_arrival_strategy) }
    let(:reciver_2) { Multilateration::Receiver.new(Vector[50,50,33],      time_unit_of_arrival_strategy) }
    let(:reciver_3) { Multilateration::Receiver.new(Vector[23,75,4],       time_unit_of_arrival_strategy) }
    let(:reciver_4) { Multilateration::Receiver.new(Vector[100,-100,-5.5], time_unit_of_arrival_strategy) }
    let(:recivers) { [reciver_0, reciver_1, reciver_2, reciver_3, reciver_4] }

    subject(:solved_emitter) { described_class.new(recivers, wave_speed).solved_emitter }

    specify { expect( solved_emitter.magnitude ).to be_within(0.0000000000001).of(seeded_emitter.magnitude) }
  end
end

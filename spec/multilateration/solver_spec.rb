require 'spec_helper'

describe Multilateration::Solver do
  describe "#solved_signal_event_emitter" do
    generative do
      let(:tolerance) { 0.0000001 }

      let(:signal_event_data) { Multilateration::SignalEventDataGenerator.generate }
      let(:signal_event_emiter) { signal_event_data.fetch(:emitter_event) }
      let(:signal_event_emiter_time) { signal_event_emiter[:time] }
      let(:signal_event_emiter_coordinate) { signal_event_emiter[:coordinate] }
      let(:signal_event_data_without_emiter) { signal_event_data.reject { |k,v| v == signal_event_emiter } }

      subject(:solved_signal_event_emitter) { described_class.new(signal_event_data_without_emiter).solved_signal_event_emitter }

      specify { expect(solved_signal_event_emitter).to match({
        coordinate: [
          be_within(tolerance).of(signal_event_emiter_coordinate[0]),
          be_within(tolerance).of(signal_event_emiter_coordinate[1]),
          be_within(tolerance).of(signal_event_emiter_coordinate[2]),
        ],
        time: be_within(tolerance).of(signal_event_emiter_time),
      })}
    end
  end

end

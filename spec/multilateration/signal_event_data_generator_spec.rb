require 'spec_helper'

describe Multilateration::SignalEventDataGenerator do
  describe '.generate' do
    subject(:generate) { described_class.generate }

    let(:signal_event_matcher) do
      {
        coordinate: [be_a(Numeric), be_a(Numeric), be_a(Numeric)],        # [368, -454, 978.9]
        # timestamp: match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{9}(\+|\-)\d{4}$/) # "1945-12-22T18:13:16.144102423+0000"
        time: be_a(Time),
      }
    end

    specify { expect(generate).to match(
      signal_propagation_speed: be_a(Numeric),
      emitter_event: signal_event_matcher,
      receiver_events: [signal_event_matcher,signal_event_matcher,signal_event_matcher,signal_event_matcher,signal_event_matcher],
    )}
  end
end

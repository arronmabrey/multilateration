require 'spec_helper'

describe Multilateration::SignalEventsGenerator do
  describe '.generate' do
    subject(:generate) { described_class.generate }

    let(:signal_event_matcher) do
      {
        coordinate: [be_a(Numeric), be_a(Numeric), be_a(Numeric)],        # [368, -454, 978.9]
        time: match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{9}\+0{4}$/) # "1945-12-22T18:13:16.144102423+0000"
      }
    end

    let(:signal_event_emitter_matcher) { signal_event_matcher.merge(type: :emitter) }
    let(:signal_event_receiver_matcher) { signal_event_matcher.merge(type: :receiver) }

    specify { expect(generate).to match [
        signal_event_emitter_matcher,
        signal_event_receiver_matcher,
        signal_event_receiver_matcher,
        signal_event_receiver_matcher,
        signal_event_receiver_matcher,
        signal_event_receiver_matcher,
    ] }
  end
end

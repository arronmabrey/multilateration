require 'spec_helper'

describe Multilateration::Emitter do
  describe "#magnitude" do
    let(:vector) { Vector[1,2,3] }
    subject(:magnitude) { described_class.new(vector).magnitude }
    specify { expect( magnitude ).to eq(vector.magnitude) }
  end
end

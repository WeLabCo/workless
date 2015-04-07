require 'spec_helper'

describe Delayed::Workless::Scaler::OfficeHoursWrapper do
  let(:wrapped_scaler) { Delayed::Workless::Scaler::Local }

  before do
    ENV['WORKLESS_OFFICE_HOURS'] = '9..19'
    ENV['WORKLESS_OFFICE_DAYS'] = '1..5'

    described_class.scaler = wrapped_scaler
  end

  context 'in office hours' do
    before { Timecop.freeze(2015, 3, 26, 10) }

    it 'scales up with wrapped scaler' do
      expect(wrapped_scaler).to receive(:up)
      described_class.up
    end

    it 'does not scale down' do
      expect(wrapped_scaler).not_to receive(:down)
      described_class.down
    end
  end

  context 'out of office hours' do
    shared_examples_for :out_of_office_hours do
      it 'scales up with wrapped scaler' do
        expect(wrapped_scaler).to receive(:up)
        described_class.up
      end

      it 'scales down with wrapped scaler' do
        expect(wrapped_scaler).to receive(:down)
        described_class.down
      end
    end

    context 'out of office days but in office hours' do
      before { Timecop.freeze(2015, 3, 28, 14) }
      it_behaves_like :out_of_office_hours
    end

    context 'in office days but out of office hours' do
      before { Timecop.freeze(2015, 3, 26, 20) }
      it_behaves_like :out_of_office_hours
    end
  end

end

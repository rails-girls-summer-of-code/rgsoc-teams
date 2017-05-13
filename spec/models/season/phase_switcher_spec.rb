require 'spec_helper'

describe Season::PhaseSwitcher do

  it "is available as described class" do
    expect(described_class).to eq Season::PhaseSwitcher
  end

  context 'when switching phases' do
    season = Season.current

    context 'when the input is valid' do
      it 'gets called on the season object' do
        phase = :fake_application_phase
        described_class.destined(phase)
        season.reload
        expect(season).to be_application_period
      end

      it 'changes also when real time happens to be within application_period' do
        phase = :fake_proposals_phase
        described_class.destined(phase)
        season.reload
        expect(season).not_to be_application_period
      end
    end

    context 'when the input is malicious' do
      phase = :bad_intentions

      it 'raises an error when it receives a non-whitelisted phase' do
        expect {
          described_class.destined(phase)
        }.to raise_error(ArgumentError)
      end
      it 'does not change the season dates' do
        expect {
          described_class.destined(phase) rescue ArgumentError
        }.not_to change { Season.current.reload }
      end
    end
  end
end

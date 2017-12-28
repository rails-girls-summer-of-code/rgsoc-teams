require 'spec_helper'

RSpec.describe NavHelper, type: :helper do
  describe '#during_season?' do
    subject { helper.during_season? }

    before { allow(helper).to receive(:current_season).and_return(season) }

    context 'when the season started and is not transitioning' do
      let(:season) { instance_double(Season, started?: true, transition?: false) }

      it { is_expected.to eq true }
    end

    context 'when the season started and is transitioning' do
      let(:season) { instance_double(Season, started?: true, transition?: true) }

      it { is_expected.to eq false }
    end

    context 'when the season did not start yet' do
      let(:season) { instance_double(Season, started?: false, transition?: false) }

      it { is_expected.to eq false }
    end
  end

  describe '#during_application_phase?' do
    subject { helper.during_application_phase? }

    before { allow(helper).to receive(:current_season).and_return(season) }

    context 'during application_period' do
      let(:season) { instance_double(Season, application_period?: true) }

      it { is_expected.to eq true }
    end

    context 'after application_period but before acceptance_notifications' do
      let(:season) do
        instance_double(Season,
          application_period?:        false,
          applications_close_at:      1.day.ago.utc,
          acceptance_notification_at: 2.days.from_now.utc
        )
      end

      it { is_expected.to eq true }
    end

    context 'after summer started' do
      let(:season) do
        instance_double(Season,
          application_period?:        false,
          applications_close_at:      2.days.ago.utc,
          acceptance_notification_at: 1.days.ago.utc
        )
      end

      it { is_expected.to eq false }
    end
  end
end

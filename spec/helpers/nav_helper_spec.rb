require 'rails_helper'

RSpec.describe NavHelper, type: :helper do
  describe '#active_if' do
    subject(:css_class) { helper.active_if(path) }

    let(:path) { 'some/random/path' }

    it 'returns the active css class if the given path is the current one' do
      expect(helper).to receive(:current_page?).with(path).and_return(true)
      expect(css_class).to eq 'active'
    end

    it 'returns nothing if the given path is not the current one' do
      expect(helper).to receive(:current_page?).with(path).and_return(false)
      expect(css_class).to be_nil
    end
  end

  describe '#active_if_soc_dropdown_active' do
    subject(:css_class) { helper.active_if_soc_dropdown_active }

    it 'returns active for all controller specified in the helper' do
      described_class::SOC_CONTROLLERS.each do |controller|
        params = ActionController::Parameters.new(controller: controller)
        allow(helper).to receive(:params).and_return(params)
        expect(helper.active_if_soc_dropdown_active).to eq 'active'
      end
    end

    it 'returns nil for any other controller' do
      params = ActionController::Parameters.new(controller: 'something_random')
      allow(helper).to receive(:params).and_return(params)
      expect(css_class).to be_nil
    end
  end

  describe '#active_if_controller' do
    subject(:css_class) { helper.active_if_controller(controller_name) }

    let(:controller_name) { 'some_random_string' }

    it 'returns active if the given controller matches the current page' do
      params = ActionController::Parameters.new(controller: controller_name)
      allow(helper).to receive(:params).and_return(params)
      expect(css_class).to eq 'active'
    end

    it 'returns nil if the controller does not match' do
      params = ActionController::Parameters.new(controller: 'something_else')
      allow(helper).to receive(:params).and_return(params)
      expect(css_class).to be_nil
    end
  end

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
          acceptance_notification_at: 1.day.ago.utc
        )
      end

      it { is_expected.to eq false }
    end
  end
end

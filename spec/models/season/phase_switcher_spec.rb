require 'spec_helper'


context 'when switching phases' do
  subject { Season.current }


  describe 'destined' do
    it 'sends the params to a phase setting method' do
      phase = :fake_application_phase
      Season::PhaseSwitcher.destined(phase)
      expect(subject).to be_application_period
    end

    it 'addresses the requested phase' do
      phase = :fake_proposals_phase
      Season::PhaseSwitcher.destined(phase)
      expect(subject).to_not be_application_period
    end

    it 'fails silently when it receives a non-whitelisted phase' do
      phase = :bad_intentions
      bad_call = Season::PhaseSwitcher.destined(phase)
      expect( bad_call ).to be_nil
    end
  end

  describe '#fake_application_phase' do
    it 'timeshifts the application phase to today' do
      Timecop.travel(Season.current.applications_close_at - 1.month) do
        Season::PhaseSwitcher.fake_application_phase
        expect(subject).to be_application_period
      end
    end
  end

  describe '#fake_coding_phase' do
    it 'timeshifts the coding phase to today' do
      Timecop.travel(Season.current.ends_at - 1.week) do
        Season::PhaseSwitcher.fake_coding_phase
        expect(subject).to be_started
      end
    end
  end

  describe '#fake_proposals_phase' do
    it 'timeshifts the proposal period to today' do
      Timecop.travel(Season.current.project_proposals_close_at - 2.weeks) do
        fake_time = Time.now #as returned by Timecop
        Season::PhaseSwitcher.fake_proposals_phase
        expect(subject.project_proposals_open_at).to be < fake_time
        expect(subject.project_proposals_close_at).to be > fake_time
      end
    end
  end
end
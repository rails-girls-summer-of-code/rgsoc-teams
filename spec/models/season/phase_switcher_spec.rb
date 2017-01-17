require 'spec_helper'


context 'when switching phases' do
  subject { Season.current }

  describe 'destined' do

    it 'sends the params to a phase setting method' do
      phase = 'fake_application_phase'
      Season::PhaseSwitcher.destined(phase)
      expect(subject).to_not be_nil
    end

    context 'when directed to the #fake_application_phase' do
      it 'sets date range so that the season is open for application submissions' do
        phase = 'fake_application_phase'
        Timecop.travel(Season.current.applications_close_at - 1.month) do
          Season::PhaseSwitcher.destined(phase)
          expect(subject).to_not be_nil
          expect(subject).to be_application_period
        end
      end
    end

    context 'when directed to the #fake_coding_phase' do
      it 'sets dates so that the summer of code is currently happening' do
        phase = 'fake_coding_phase'
        Timecop.travel(Season.current.ends_at - 1.week) do
          Season::PhaseSwitcher.destined(phase)
          expect(subject).to be_started
        end
      end
    end

    context 'when directed to the #fake_proposals_phase' do
      it 'set dates so that season is open for project proposals' do
        phase = 'fake_proposals_phase'
        Timecop.travel(Season.current.project_proposals_close_at - 2.weeks) do
          fake_time = Time.now #as returned by Timecop
          Season::PhaseSwitcher.destined(phase)
          expect(subject.project_proposals_open_at).to be < fake_time
          expect(subject.project_proposals_close_at).to be > fake_time
        end
      end
    end

    it 'addresses the requested phase' do
      another_phase = 'fake_proposals_phase'
      Season::PhaseSwitcher.destined(another_phase)
      expect(subject).to_not be_application_period
    end

    it 'fails silently when it receives a non-whitelisted phase' do
      phase = 'bad_intentions'
      forbidden_call = Season::PhaseSwitcher.destined(phase)
      expect { forbidden_call }.not_to change { Season.current.updated_at }
    end

  end
end

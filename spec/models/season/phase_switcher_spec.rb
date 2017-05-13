require 'spec_helper'


context 'when switching phases' do
  subject { Season.current }

  describe 'destined' do

    xit 'sends the params to a phase setting method' do
      phase = Season::PhaseSwitcher::WHITELISTED_PHASES.first
      expect(subject).to respond_to(Season::PhaseSwitcher.destined(phase: phase))
    end

    context 'when directed to the #fake_application_phase' do
      it 'sets date range so that the season is open for application submissions' do
        phase = :fake_application_phase
        Timecop.travel(Season.current.applications_close_at - 1.month) do
          Season::PhaseSwitcher.destined(phase: phase)
          expect(subject).to_not be_nil
          expect(subject).to be_application_period
        end
      end
    end

    context 'when directed to the #fake_coding_phase' do
      it 'sets dates so that the summer of code is currently happening' do
        phase = :fake_coding_phase
        Timecop.travel(Season.current.ends_at - 1.week) do
          Season::PhaseSwitcher.destined(phase: phase)
          expect(subject).to be_started
        end
      end
    end

    context 'when directed to the #fake_proposals_phase' do
      it 'set dates so that season is open for project proposals' do
        phase = :fake_proposals_phase
        Timecop.travel(Season.current.project_proposals_close_at - 2.weeks) do
          fake_time = Time.now #as returned by Timecop
          Season::PhaseSwitcher.destined(phase: phase)
          expect(subject.project_proposals_open_at).to be < fake_time
          expect(subject.project_proposals_close_at).to be > fake_time
        end
      end
    end

    it 'addresses the requested phase' do
      another_phase = :fake_proposals_phase

      Season::PhaseSwitcher.destined(phase: another_phase)
      # Just checking, here too the error is not raised
      Season.current
      allow_any_instance_of(Season).to receive(:save).and_raise RuntimeError
      expect(subject).to_not be_application_period
    end

    context 'it does not accept malicious input' do
      phase = :bad_intentions

      it 'raises an error when it receives a non-whitelisted phase' do
        expect { Season::PhaseSwitcher.destined(phase: phase) }.to raise_error(ArgumentError)
      end
      it 'does not change the subject' do
        expect { Season::PhaseSwitcher.destined(phase: phase) rescue ArgumentError }.not_to change { subject.reload }
      end
    end
  end
end

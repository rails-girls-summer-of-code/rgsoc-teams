require 'spec_helper'

describe TeamPerformance do
  let :team_nothing do
    build_stubbed :team
  end

  let :team_activitiy do
    team = create :team
    create :activity, team: team
    team
  end

  let :team_commented do
    team = create :team
    create :comment, team: team
    team
  end

  let :team_both_outdated do
    team = create :team
    create :comment, team: team, created_at: 4.days.ago
    create :activity, team: team, created_at: 4.days.ago
    team
  end

  let :team_both do
    team = create :team
    create :comment, team: team
    create :activity, team: team
    team
  end

  context "before the season" do
    before :each do
      future_season =  build_stubbed :season, starts_at: 10.days.from_now, ends_at: 3.months.from_now
      allow(Season).to receive(:current).and_return(future_season)
    end

    describe "#evaluation" do
      context 'for a team without activites and feedback' do
        subject { TeamPerformance.new(team_nothing) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end

      context 'for a team with activities but without feedback' do
        subject { TeamPerformance.new(team_activitiy) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end

      context 'for a team without activites but with recent feedback' do
        subject { TeamPerformance.new(team_commented) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end

      context 'for a team with older activities and older feedback' do
        subject { TeamPerformance.new(team_both_outdated)}

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end

      context 'for a team with recent activites and with recent feedback' do
        subject { TeamPerformance.new(team_both) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end
    end
  end

  context "during the season" do
    before :each do
      current_season =  build_stubbed :season, starts_at: 10.days.ago, ends_at: 2.months.from_now
      allow(Season).to receive(:current).and_return(current_season)
    end

    describe "#evaluation" do
      context 'for a team without activites and feedback' do
        subject { TeamPerformance.new(team_nothing) }

        it "signals red" do
          expect(subject.evaluation).to eq(:red)
        end
      end

      context 'for a team with activities but without feedback' do
        subject { TeamPerformance.new(team_activitiy) }

        it "signals orange" do
          expect(subject.evaluation).to eq(:orange)
        end
      end

      context 'for a team without activites but with recent feedback' do
        subject { TeamPerformance.new(team_commented) }

        it "signals orange" do
          expect(subject.evaluation).to eq(:orange)
        end
      end

      context 'for a team with older activities and older feedback' do
        subject { TeamPerformance.new(team_both_outdated)}

        it "signals orange" do
          expect(subject.evaluation).to eq(:orange)
        end

        it "still signals orange after beeing called repeatedly" do
          10.times { subject.evaluation }

          expect(subject.evaluation).to eq(:orange)
        end
      end

      context 'for a team with recent activites and with recent feedback' do
        subject { TeamPerformance.new(team_both) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end
    end
  end


  context "after the season" do
    before :each do
      past_season =  build_stubbed :season, starts_at: 2.months.ago, ends_at: 10.days.ago
      allow(Season).to receive(:current).and_return(past_season)
    end

    describe "#evaluation" do
      context 'for a team without activites and feedback' do
        subject { TeamPerformance.new(team_nothing) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end

      context 'for a team with activities but without feedback' do
        subject { TeamPerformance.new(team_activitiy) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end

      context 'for a team without activites but with recent feedback' do
        subject { TeamPerformance.new(team_commented) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end

      context 'for a team with older activities and older feedback' do
        subject { TeamPerformance.new(team_both_outdated)}

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end

      context 'for a team with recent activites and with recent feedback' do
        subject { TeamPerformance.new(team_both) }

        it "signals green" do
          expect(subject.evaluation).to eq(:green)
        end
      end
    end
  end
end

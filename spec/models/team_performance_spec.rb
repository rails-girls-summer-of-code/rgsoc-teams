require 'spec_helper'

describe TeamPerformance do
  let(:future_season) { build_stubbed :season, starts_at: 10.days.from_now, ends_at: 3.months.from_now }
  let(:current_season) { build_stubbed :season, starts_at: 10.days.ago, ends_at: 2.months.from_now }
  let(:past_season) { build_stubbed :season, starts_at: 2.months.ago, ends_at: 10.days.ago }

  context 'for a team without activites and feedback' do
    let(:team) { build_stubbed :team }
    subject { TeamPerformance.new(team) }

    describe "#evaluation" do
      it "signals green before the season starts" do
        allow(Season).to receive(:current).and_return(future_season)

        expect(subject.evaluation).to eq(:green)
      end

      it "signals red before the season starts" do
        allow(Season).to receive(:current).and_return(current_season)

        expect(subject.evaluation).to eq(:red)
      end

      it "signals green after the season ends" do
        allow(Season).to receive(:current).and_return(past_season)

        expect(subject.evaluation).to eq(:green)
      end
    end
  end

  context 'for a team without activites but with recent feedback' do
    let(:team) { create :team }
    before { create :comment, team: team }
    subject { TeamPerformance.new(team) }

    it "signals green before the season starts" do
      allow(Season).to receive(:current).and_return(future_season)

      expect(subject.evaluation).to eq(:green)
    end

    it "signals orange during the season" do
      allow(Season).to receive(:current).and_return(current_season)

      expect(subject.evaluation).to eq(:orange)
    end

    it "signals orange after evaluation was called multiple times" do
      allow(Season).to receive(:current).and_return(current_season)

      10.times { subject.evaluation }
      expect(subject.evaluation).to eq(:orange)
    end

    it "signals green after the season" do
      allow(Season).to receive(:current).and_return(past_season)

      expect(subject.evaluation).to eq(:green)
    end
  end

  context 'for a team with recent activities but without feedback' do
    let(:team) { create :team }
    before { create :activity, team: team }
    subject { TeamPerformance.new(team) }

    it "signals green before the season starts" do
      allow(Season).to receive(:current).and_return(future_season)

      expect(subject.evaluation).to eq(:green)
    end

    it "signals orange during the season" do
      allow(Season).to receive(:current).and_return(current_season)

      expect(subject.evaluation).to eq(:orange)
    end

    it "signals green after the season" do
      allow(Season).to receive(:current).and_return(past_season)

      expect(subject.evaluation).to eq(:green)
    end
  end

  context 'for a team with older activities and older feedback' do
    let(:team) { create :team }
    before { create :comment, team: team, created_at: 4.days.ago }
    before { create :activity, team: team, created_at: 4.days.ago }
    subject { TeamPerformance.new(team) }

    it "signals green before the season starts" do
      allow(Season).to receive(:current).and_return(future_season)

      expect(subject.evaluation).to eq(:green)
    end

    it "signals orange during the season" do
      allow(Season).to receive(:current).and_return(current_season)

      expect(subject.evaluation).to eq(:orange)
    end

    it "signals green after the season" do
      allow(Season).to receive(:current).and_return(past_season)

      expect(subject.evaluation).to eq(:green)
    end
  end

  context 'for a team with recent activities and recent feedback' do
    let(:team) { create :team }
    before { create :comment, team: team }
    before { create :activity, team: team }
    subject { TeamPerformance.new(team) }

    it "signals green before the season starts" do
      allow(Season).to receive(:current).and_return(future_season)

      expect(subject.evaluation).to eq(:green)
    end

    it "signals green during the season" do
      allow(Season).to receive(:current).and_return(current_season)

      expect(subject.evaluation).to eq(:green)
    end

    it "signals green after the season" do
      allow(Season).to receive(:current).and_return(past_season)

      expect(subject.evaluation).to eq(:green)
    end
  end
end

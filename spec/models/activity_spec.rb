require 'spec_helper'

describe Activity do
  it { is_expected.to belong_to(:team) }

  describe 'scopes' do
    describe '.with_kind' do
      it 'queries for activities with a kind' do
        kind = Activity::KINDS.sample
        expect(Activity.with_kind(kind).where_values_hash).to eq("kind" => kind)
      end
    end

    describe '.by_team' do
      it 'queries for activities with a team_id' do
        team_id = rand(10)
        expect(Activity.by_team(team_id).where_values_hash).to eq("team_id" => team_id)
      end
    end

    describe '.ordered' do
      it 'queries with a specific order' do
        expect(Activity.ordered.order_values).to eq(["published_at DESC, id DESC"])
      end
    end
  end
end

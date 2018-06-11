require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:team).optional }
    it { is_expected.to have_many(:comments).dependent(:destroy) }

    it { is_expected.to delegate_method(:students).to(:team) }
  end

  describe 'validations' do
    context 'for kind "status_update"' do
      subject { described_class.new kind: 'status_update' }

      it { is_expected.to validate_presence_of :team }
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_presence_of :content }
    end
  end

  describe '#to_param' do
    it 'appends the parameterized title' do
      subject.id    = 42
      subject.title = 'Foo Bar - With dashes _ and underscores!'
      expect(subject.to_param).to eql "42-foo-bar-with-dashes-_-and-underscores"
    end
  end

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

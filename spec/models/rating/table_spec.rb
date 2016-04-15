require 'spec_helper'

describe Rating::Table do
  describe 'attributes' do
    let(:users) { create_list :user, 3 }
    let(:user_names) { users.map(&:name) }
    let(:applications) { create_list :application, 3 }
    let(:options) { {order: :average_points, hide_flags: []} }

    let(:table) { Rating::Table.new user_names, applications, options }

    it 'has names' do
      expect(table.names).to eq user_names
    end

    it 'has options' do
      expect(table.options).to eq options
    end

    it 'has rows' do
      expect(table.rows.size).to eq applications.count
      expect(table.rows).to all be_a Rating::Table::Row
    end

    it 'has order' do
      expect(table.order).to eq options[:order]
    end
  end
  describe 'filtering' do
    let(:users) { create_list :user, 3 }
    let(:user_names) { users.map(&:name) }
    let!(:remote_team_application) { create :application, flags: [:remote_team] }
    let!(:other_applications) { create_list :application, 3 }
    let(:table) { Rating::Table.new user_names, Application.all, options }

    context 'when hide_flags given' do
      let(:options) { {order: :average_points, hide_flags: ["remote_team"]} }

      it 'excludes rows / applications flagged with hidden flags' do
        expect(table.rows.map{|r| r.application}).to match_array other_applications
      end
    end
    context 'when not hide_flags given' do
      let(:options) { {order: :average_points} }

      it 'returns all applications' do
        expect(table.rows.map{|r| r.application}).to match_array Application.all
      end
    end
  end
end

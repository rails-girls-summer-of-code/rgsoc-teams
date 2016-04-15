require 'spec_helper'

describe Rating::Table do
  describe 'attributes' do
    let(:users) { create_list :user, 3 }
    let(:user_names) { users.map(&:name) }
    let(:applications) { create_list :application, 3 }
    let(:options) { {order: :average_points} }

    let(:table) { described_class.new(user_names, applications, options) }

    describe '#names' do
      it 'is readonly' do
        expect(table).to respond_to :names
        expect(table).not_to respond_to "names="
      end

      it 'contains passed user_names' do
        expect(table.names).to match_array user_names
      end
    end
    describe '#options' do
      it 'is readonly' do
        expect(table).to respond_to :options
        expect(table).not_to respond_to "options="
      end

      it 'contains passed options_hash' do
        expect(table.options).to eq options
      end
    end
    describe '#rows' do
      it 'is readonly' do
        expect(table).to respond_to :rows
        expect(table).not_to respond_to "rows="
      end

      it 'contains an ::Row for each passed application' do
        expect(table.rows.size).to eq applications.count
        expect(table.rows).to all be_a described_class::Row
      end
    end
    describe '#order' do
      it 'is readonly' do
        expect(table).to respond_to :order
        expect(table).not_to respond_to "order="
      end

      it 'contains the passed order-option as a sym' do
        expect(table.order).to eq options[:order]
      end

      it 'contains :id if no valid order passed (currently not working)'
    end
  end
end

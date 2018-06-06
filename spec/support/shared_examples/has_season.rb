RSpec.shared_examples 'HasSeason' do
  it { is_expected.to belong_to(:season).optional }

  describe '.in_season' do
    it 'returns a relation' do
      expect(described_class.in_season('1984')).to be_kind_of ActiveRecord::Relation
    end

    it 'accepts an String as well as any object responding to #name' do
      sql_string = described_class.in_season('test').to_sql
      sql_double = described_class.in_season(double(name: 'test')).to_sql

      expect(sql_double).to eql sql_string
    end
  end
end

require 'spec_helper'

describe Application do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:application_data) }

  describe 'scopes' do
    describe '.hidden' do
      it 'retruns only hidden applications' do
        expect(Application.hidden.where_values).to eq(["applications.hidden IS NOT NULL and applications.hidden = 't'"])
      end
    end

    describe '.visible' do
      it 'retruns only visible applications' do
        expect(Application.visible.where_values).to eq(["applications.hidden IS NULL or applications.hidden = 'f'"])
      end
    end
  end
end

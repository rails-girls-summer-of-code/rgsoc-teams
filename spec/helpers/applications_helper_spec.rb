require 'spec_helper'

describe ApplicationsHelper do
  describe '.rating_classes_for' do
    let(:user) { mock_model(User) }
    let(:rating) { mock_model(Rating) }

    before(:each) do
      allow(rating).to receive(:pick?).and_return(false)
      allow(rating).to receive(:user).and_return(nil)
    end

    it 'returns an empty string' do
      expect(rating_classes_for(rating, user)).to eq('')
    end

    it 'returns "pick" when pick is true' do
      allow(rating).to receive(:pick?).and_return(true)
      expect(rating_classes_for(rating, user)).to eq('pick')
    end

    it 'returns "own_rating" when rating user and user match' do
      allow(rating).to receive(:user).and_return(user)
      expect(rating_classes_for(rating, user)).to eq('own_rating')
    end
  end

  describe '.application_classes_for' do
    let(:application) { mock_model(Application) }

    before do
      allow(application).to receive(:selected?).and_return(false)
      allow(application).to receive(:volunteering_team?).and_return(false)
    end

    it 'cycles through even and odd' do
      expect(application_classes_for(application)).to eq('even')
      expect(application_classes_for(application)).to eq('odd')
    end

    it 'returns "selected" when selected? is true' do
      allow(application).to receive(:selected?).and_return(true)
      expect(application_classes_for(application)).to match('selected')
    end

    it 'returns "volunteering_team" when volunteering_team? is true' do
      allow(application).to receive(:volunteering_team?).and_return(true)
      expect(application_classes_for(application)).to match('volunteering_team')
    end
  end

end

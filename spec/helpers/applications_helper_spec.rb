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

  describe '#application_disambiguation_link' do
    let(:draft) { create :application_draft }
    let(:user)  { create :user }

    subject { helper.application_disambiguation_link }

    it 'returns an "Apply now" link for an anonymous user' do
      allow(helper).to receive(:current_student).and_return(Student.new)
      allow(helper).to receive(:current_user)

      expect(subject).to match 'Apply now'
      expect(subject).to match apply_path
    end

    context 'as a guide' do
      let(:guide_role) { %w(coach mentor).sample }

      before do
        allow(helper).to receive(:current_student).and_return(Student.new user)
      end

      it 'returns a link to the drafts list' do
        create "#{guide_role}_role", user: user, team: draft.team
        allow(helper).to receive(:current_user).and_return(user)
        expect(subject).to match 'Applications'
        expect(subject).to match application_drafts_path
      end

    end

  end
end

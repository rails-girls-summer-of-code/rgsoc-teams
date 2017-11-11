RSpec.shared_examples 'Rateable' do
  it { is_expected.to have_many(:ratings) }

  describe '#average_points' do
    subject { rateable.average_points }

    context 'when no rating' do
      it 'returns zero' do
        expect(subject).to be_zero
      end
    end

    context 'when ratings' do
      before do
        create_list(:rating, 2,
          rateable: rateable,
          data:     { 'diversity' => 1 }
        )
      end

      it 'retuns the average of points' do
        expect(subject).to eq 0.05
      end
    end
  end

  describe '#median_points' do
    subject { rateable.median_points }

    context 'when no rating' do
      it 'returns zero' do
        expect(subject).to be_zero
      end
    end

    context 'when even ratings' do
      before do
        create_list(:rating, 2,
          rateable: rateable,
          data:     { 'diversity' => 1 }
        )

        create_list(:rating, 2,
          rateable: rateable,
          data:     { 'diversity' => 5 }
        )
      end

      it 'retuns the average of points' do
        expect(subject).to eq 0.15
      end
    end

    context 'when odd ratings' do
      before do
        create_list(:rating, 2,
          rateable: rateable,
          data:     { 'diversity' => 1 }
        )

        create_list(:rating, 1,
          rateable: rateable,
          data:     { 'diversity' => 4 }
        )
      end

      it 'retuns the average of points' do
        expect(subject).to eq 0.05
      end
    end
  end

  describe '#ratings_short' do
    subject { rateable.ratings_short }

    context 'when no ratings' do
      it 'returns an emtpy Array' do
        expect(subject).to be_empty
      end
    end

    context 'when ratings' do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      before do
        create(:rating, rateable: rateable, user: user1)
        create(:rating, rateable: rateable, user: user2)
      end

      it 'retuns the users names and points' do
        expect(subject).to contain_exactly(
          "#{user1.name}: 0.0",
          "#{user2.name}: 0.0"
        )
      end
    end
  end

  describe '#total_picks' do
    subject { rateable.total_picks }

    context 'when no ratings yet' do
      it 'returns zero' do
        expect(subject).to eq 0
      end
    end

    context 'when ratings' do
      before do
        create_list(:rating, 2, rateable: rateable, pick: true)
        create_list(:rating, 2, rateable: rateable)
      end

      it 'returns the sum of picks given' do
        expect(subject).to eq 2
      end
    end
  end

  describe '#total_likes' do
    subject { rateable.total_likes }

    context 'when no ratings yet' do
      it 'returns zero' do
        expect(subject).to eq 0
      end
    end

    context 'when ratings' do
      before do
        create_list(:rating, 2, rateable: rateable, like: true)
        create_list(:rating, 2, rateable: rateable)
      end

      it 'returns the sum of likes given' do
        expect(subject).to eq 2
      end
    end
  end
end

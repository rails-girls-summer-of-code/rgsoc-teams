require 'rails_helper'

RSpec.describe Selection::Strictness, type: :model do
  describe '#adjusted_points_for_applications' do
    subject { described_class.new.adjusted_points_for_applications }

    # This is not a realistic test scenarion (i.e. we will never ever
    # have just one application), but it's an important mathematical
    # requirement.
    context "when there's only one application" do
      let!(:application) { create :application, :in_current_season }

      let!(:rating1) { create :rating, application: application }
      let!(:rating2) { create :rating, application: application }

      context 'when reviewers rate equally' do
        before { allow_any_instance_of(Rating).to receive(:points) { 5.0 } }

        it 'reduces to arithmetic mean' do
          expect(subject).to eql({ application.id => 5.0 })
        end
      end

      context 'when one reviewer rates stricter than the other' do
        # We still want to stub Rating#points, but we need different
        # valus. Return `a` for the first rating, `b` else.
        let(:points) { ->(rating) { rating == rating1 ? 4.0 : 8.0 } }
        before { allow_any_instance_of(Rating).to receive(:points, &points) }

        it 'reduces to arithmetic mean' do
          expect(subject).to eql({ application.id => 6.0 })
        end
      end
    end

    context 'with two applications rated by two reviewers' do
      let!(:application1) { create :application, :in_current_season }
      let!(:application2) { create :application, :in_current_season }

      let!(:reviewers) { create_list :user, 2 }

      let!(:rating1) { create :rating, application: application1, user: reviewers.first  }
      let!(:rating2) { create :rating, application: application2, user: reviewers.first  }
      let!(:rating3) { create :rating, application: application1, user: reviewers.second }
      let!(:rating4) { create :rating, application: application2, user: reviewers.second }

      # We still want to stub Rating#points, but we need different
      # valus. Return `a` for the first rating, `b` else.
      let(:points) do
        lambda { |rating|
          case rating
          when rating1 then 2.0 # reviewer1 for application1
          when rating2 then 6.0 # reviewer1 for application2
          when rating3 then 4.0 # reviewer2 for application1
          when rating4 then 8.0 # reviewer2 for application2
          end
        }
      end

      # Convenience methods
      let(:ratings_for_application1) { [rating1, rating3] }
      let(:ratings_for_application2) { [rating2, rating4] }

      before { allow_any_instance_of(Rating).to receive(:points, &points) }

      # Ensure monotony: Both reviewers rated application2 higher
      it { expect(subject[application2.id]).to be > subject[application1.id] }

      it 'both penalizes and bumps the original rating' do
        untainted_arithmetic_mean_for_application1 = \
          ratings_for_application1.sum(&:points) / ratings_for_application1.size.to_f
        untainted_arithmetic_mean_for_application2 = \
          ratings_for_application2.sum(&:points) / ratings_for_application2.size.to_f

        expect(untainted_arithmetic_mean_for_application1).to be > subject[application1.id]
        expect(untainted_arithmetic_mean_for_application2).to be < subject[application2.id]
      end
    end
  end
end

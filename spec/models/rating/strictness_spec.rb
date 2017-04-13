require 'spec_helper'

RSpec.describe Rating::Strictness do


  describe '#adjusted_points_for_applications' do
    subject { described_class.new.adjusted_points_for_applications }

    # This is not a realistic test scenarion (i.e. we will never ever
    # have just one application), but it's an important mathematical
    # requirement.
    context "when there's only one application" do
      let!(:application) { create :application, :in_current_season }

      let!(:rating1) { create :rating, rateable: application }
      let!(:rating2) { create :rating, rateable: application }

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

  end

end

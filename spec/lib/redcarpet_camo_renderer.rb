require 'rails_helper'

RSpec.describe Redcarpet::Render::Camo do
  describe '#image' do
    let(:markdown) { "![hello](#{image})" }

    subject { Redcarpet::Markdown.new(described_class).render(markdown) }

    context 'with camo environment variables not set' do
      before do
        allow(ENV).to receive(:[]).with('CAMO_HOST')
        allow(ENV).to receive(:[]).with('CAMO_KEY')
      end

      context 'for a secure image' do
        let(:image) { "https://something.securely.funny/foo.gif" }

        it 'renders the image as-is' do
          expect(subject).to match %r[src="https://something.securely.funny/foo.gif"]
        end
      end

      context 'for an insecure image' do
        let(:image) { "http://something.funny/foo.gif" }

        it 'renders the image as-is' do
          expect(subject).to match %r[src="http://something.funny/foo.gif"]
        end
      end
    end

    context 'with camo environment variables set' do
      let(:camo_host) { 'https://rgsoc-teams-camo.herokuapp.com' }

      before do
        allow(ENV).to receive(:[]).with('CAMO_HOST') { camo_host }
        allow(ENV).to receive(:[]).with('CAMO_KEY')  { SecureRandom.hex }
      end

      context 'for a secure image' do
        let(:image) { "https://something.securely.funny/foo.gif" }

        it 'renders the image as-is' do
          expect(subject).to match %r[src="https://something.securely.funny/foo.gif"]
        end
      end

      context 'for an insecure image' do
        let(:image) { "http://something.funny/foo.gif" }

        it 'renders the image as-is' do
          expect(subject).to match %r[src="#{camo_host}]
        end
      end
    end
  end
end

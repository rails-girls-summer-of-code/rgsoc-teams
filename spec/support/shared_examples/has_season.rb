RSpec.shared_examples 'HasSeason' do
  it { expect(subject).to belong_to :season }
end

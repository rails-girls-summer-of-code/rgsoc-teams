RSpec.shared_examples 'GithubHandle' do
  it { expect(subject.github_handle).to be true }
end
require 'rails_helper'
require 'github/user'

RSpec.describe Github::User do
  before :each do
    stub_request(:get, /./).to_return(body: File.read('spec/stubs/github/user.json'))
  end

  it 'fetches the user from GitHub and normalizes attributes' do
    expect(Github::User.new('octocat').attrs).to eq({
      github_id:  1,
      name:       'monalisa octocat',
      email:      'octocat@github.com',
      location:   'San Francisco',
      bio:        'There once was...',
      avatar_url: 'https://github.com/images/error/octocat_happy.gif',
      homepage:   'https://github.com/blog'
    })
  end
end

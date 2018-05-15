# TODO find a place to put the arrays once, not here and in the spec
public_pages = [Activity, Team, Project ].freeze
user_pages = [User]
restricted_pages = [Application, ApplicationDraft] # todo

shared_examples 'can read public pages' do
  it "has access to public pages" do
    public_pages.each do |page|
      expect(subject).to be_able_to(:read, page)
    end
  end
  it {expect(subject).to be_able_to(:read, User) }
end

shared_examples "has access to restricted pages" do
  restricted_pages.each do |page|
    expect(subject).to be_able_to(:read, page)
  end
end

# Shared examples for User
shared_examples "has no access to other user's accounts" do # pro memorie: outside their team
  it { expect(subject).not_to be_able_to([:update, :destroy], other_user) }
end

shared_examples "can modify own account" do
  it { expect(subject).to be_able_to([:update, :destroy], user) }
end

shared_examples 'can not create new user' do
  it { expect(subject).not_to be_able_to(:create, User.new) }
end

# Shared examples for logged in users
shared_examples "can do more stuff when logged in" do
  it 'can add comments' do #
    pending "todo"
    raise "NotImplementedFakeError"
  end
  # todo and more
end

# Todo add shared_examples for other roles etc


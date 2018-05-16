# collections of shared examples

# logged in, unconfirmed:
shared_examples "same as guest user" do
  it_behaves_like "can read public pages"
  it_behaves_like "can not modify things on public pages"
  it_behaves_like "can not create new user"
  it_behaves_like "can not comment" #(= logged in pages )
  it_behaves_like "has no access to other user's accounts"
  it_behaves_like "can not read role restricted or owner restricted pages" # now: ApplicationDraft
end

# logged in and confirmed
shared_examples "same as logged in user" do
  it_behaves_like "can read public pages"
  it_behaves_like "can not create new user"
  it_behaves_like "can not comment" #(= logged in pages )
  it_behaves_like "has no access to other user's accounts"
  it_behaves_like "can not read role restricted or owner restricted pages" # now: ApplicationDraft
  it_behaves_like "can modify own account"
end

# different roles
shared_examples "same public features as confirmed user" do
  it_behaves_like "can read public pages"
  it_behaves_like "can not create new user"
  it_behaves_like "can modify own account"
end


# details

shared_examples 'can read public pages' do
  Ability::PUBLIC_PAGES.each do |page|
    it { expect(subject).to be_able_to(:read, page) }
  end
  it { expect(subject).to be_able_to(:index, Activity, kind: :feed_entry) } #TODO delete
  it { expect(subject).not_to be_able_to(:index, Activity.with_kind(:mailing)) } #TODO extract
  it { expect(subject).to be_able_to(:read, User) }
end

shared_examples "can not modify things on public pages" do
  Ability::PUBLIC_PAGES.each do |page|
    it { expect(subject).not_to be_able_to([:create, :update, :destroy], page) }
  end
end

shared_examples "can create a Project" do
  it { expect(subject).to be_able_to(:create, Project) }
end

shared_examples 'can not create new user' do
  it { expect(subject).not_to be_able_to(:create, User.new) }
end

shared_examples "can not comment" do
  Ability::LOGGED_IN_PAGES.each do |page|
   it { expect(subject).not_to be_able_to([:create, :update, :destroy], page) }
  end
end

shared_examples "can not read role restricted or owner restricted pages" do #ApplicationDraft
  it { expect(subject).not_to be_able_to(:read, ApplicationDraft) } #todo abstraction, collect pages first
  # restricted_pages.each do |page|
  #   expect(subject).to be_able_to(:read, page)
  # end
end

# Shared examples for User
shared_examples "has no access to other user's accounts" do # pro memorie: outside their team
  let(:other_user) { create(:user)}
  it { expect(subject).not_to be_able_to([:update, :destroy], other_user) }
end

shared_examples "can modify own account" do
  let(:user) {create(:user) }

  it { expect(subject).to be_able_to([:update, :destroy], user) }
  it { expect(subject).to be_able_to(:resend_confirmation_instruction, User, id: user.id) }
end

shared_examples "can comment now" do
  it { expect(subject).to be_able_to(:crud, Comment) } # TODO returns false positive; needs work
end


# This is role based? to = array of team members etc
shared_examples "can see mailings list too" do
  it { expect(subject).to be_able_to(:index, Mailing) }
end


shared_examples "can read mailings sent to them" do
  let(:user) { create(:user) }
  it { expect(subject).to be_able_to(:read, Mailing, recipient: user )}
end

# Todo add shared_examples for other roles etc


# collections of shared examples

# logged in, unconfirmed:
shared_examples "same as guest user" do
  it_behaves_like "can view public pages"
  it_behaves_like "can not modify things on public pages"
  it_behaves_like "can not create new user"
  it_behaves_like "can not comment"
  it_behaves_like "has no access to other user's accounts"
  it_behaves_like "can not read role restricted or owner restricted pages" # now: ApplicationDraft
end

# confirmed
shared_examples "same as logged in user" do
  it_behaves_like "can view public pages"
  it_behaves_like "can not create new user"
  it_behaves_like "can not comment"
  it_behaves_like "has no access to other user's accounts"
  it_behaves_like "can not read role restricted or owner restricted pages" # now: ApplicationDraft
  it_behaves_like "can modify own account"
end

# different roles
shared_examples "same public features as confirmed user" do
  it_behaves_like "can view public pages"
  it_behaves_like "can not create new user"
  it_behaves_like "can modify own account"
  # todo can creates comments; needs work
end


# DETAILS , in order of appearance

PUBLIC_INDEX_PAGES = [Activity, User, Team, Project, Conference].freeze

# details for unrestricted
shared_examples 'can view public pages' do
  PUBLIC_INDEX_PAGES.each do |page|
    it { expect(subject).to be_able_to(:read, page) }
  end
  it { expect(subject).to be_able_to(:index, Activity, kind: :feed_entry) } # TODO delete
  it { expect(subject).not_to be_able_to(:index, Activity.with_kind(:mailing)) }
  it { expect(subject).to be_able_to(:read, User) }
end

shared_examples "can not modify things on public pages" do
  PUBLIC_INDEX_PAGES.each do |page|
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
  it { expect(subject).not_to be_able_to([:create, :update, :destroy], Comment) }
end

shared_examples "has no access to other user's accounts" do # pro memorie: outside their team
  let(:other_user) { create(:user)}
  it { expect(subject).not_to be_able_to([:update, :destroy], other_user) }
end

shared_examples "can not read role restricted or owner restricted pages" do
  it { expect(subject).not_to be_able_to(:read, Application, ApplicationDraft) } # todo,  collect  all pages
end

# details for logged in
shared_examples "can modify own account" do
  let(:user) {create(:user) }

  it { expect(subject).to be_able_to([:update, :destroy], user) }
  it { expect(subject).to be_able_to(:resend_confirmation_instruction, User, id: user.id) }
end

# details for confirmed

shared_examples "can comment now" do
  xit { expect(subject).to be_able_to(:create, Comment) } # TODO returns false positive; needs work
end

shared_examples "can see mailings list too" do
  it { expect(subject).to be_able_to(:index, Mailing) }
end

shared_examples "can read mailings sent to them" do
  let(:user) { create(:user) }
  it { expect(subject).to be_able_to(:read, Mailing, recipient: user )}
end

# Todo add shared_examples for other roles etc

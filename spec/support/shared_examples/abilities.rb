PUBLIC_INDEX_PAGES = [Activity, User, Team, Project, Conference].freeze

# guest, unconfirmed and confirmed users without roles
shared_examples 'has access to public features' do
  let(:other_user) { create(:user) }

  it 'has access to public pages' do
    PUBLIC_INDEX_PAGES.each do |page|
      expect(subject).to be_able_to(:read, page)
    end
    expect(subject).not_to be_able_to(:index, Activity.with_kind(:mailing))
    expect(subject).to be_able_to(:read, User)
  end

  it "has no access to role restricted or owner restricted pages" do
    expect(subject).not_to be_able_to(:read, Application, ApplicationDraft) # todo, collect all pages
  end

  it { expect(subject).not_to be_able_to(:create, User.new) }
  it { expect(subject).not_to be_able_to([:update, :destroy], other_user) }
end

# Todo add shared_examples for other roles etc

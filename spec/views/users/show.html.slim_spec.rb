require 'spec_helper'

describe 'users/show' do
  before(:each) do
    @user = assign(:user, stub_model(User,
      name: 'Name',
      # email: 'Email',
      country: 'Zamonia',
      location: 'Location',
      bio: 'Bio',
      homepage: 'Homepage',
      role: 'coach'
    ))
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }

    allow(view).to receive(:can_see_private_info?).and_return(false)
  end

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Name/)
    # rendered.should match(/Email/)
    expect(rendered).to match @user.country
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Bio/)
    expect(rendered).to match(/Homepage/)
  end

  describe 'on its own page' do
    before :each do
      allow(@ability).to receive(:can?).with(:read, :users_info).and_return(false)
      allow(@ability).to receive(:can?).with(:edit, @user).and_return(true)
      allow(@ability).to receive(:can?).with(:destroy, @user).and_return(true)
    end

    it 'shows Edit and Destroy link if user can manage' do
      render
      expect(rendered).to match(/Edit/)
      expect(rendered).to match(/Delete Profile/)
    end
  end

  describe "on someone else's page" do
    before :each do
      allow(@ability).to receive(:can?).with(:read, :users_info).and_return(false)
      allow(@ability).to receive(:can?).with(:edit, @user).and_return(false)
      allow(@ability).to receive(:can?).with(:destroy, @user).and_return(false)
    end

    it "hides Edit and Destroy link if user can't manage" do
      render
      expect(render).not_to match(/Edit/)
      expect(render).not_to match(/Delete Profile/)
    end
  end
end

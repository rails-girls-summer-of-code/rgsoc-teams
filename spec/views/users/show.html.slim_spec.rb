require 'spec_helper'

describe 'users/show' do
  before(:each) do
    @user = assign(:user, stub_model(User,
      name: 'Name',
      # email: 'Email',
      location: 'Location',
      bio: 'Bio',
      homepage: 'Homepage',
      role: 'coach'
    ))
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
   end

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # rendered.should match(/Email/)
    rendered.should match(/Location/)
    rendered.should match(/Bio/)
    rendered.should match(/Homepage/)
  end

  describe 'on its own page' do
    before :each do
      @ability.stub!(:can?).with(:edit, @user).and_return(true)
      @ability.stub!(:can?).with(:destroy, @user).and_return(true)
    end
    it "shows Edit and Destroy link if user can manage" do
      render
      rendered.should match(/Edit/)
      rendered.should match(/Destroy/)
    end
  end

  describe "on someone else's page" do
    before :each do
      @ability.stub!(:can?).with(:edit, @user).and_return(false)
      @ability.stub!(:can?).with(:destroy, @user).and_return(false)
    end

    it "hides Edit and Destroy link if user can't manage" do
      render
      render.should_not match(/Edit/)
      render.should_not match(/Destroy/)
    end
  end
end

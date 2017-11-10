module ControllerMacros
  def login_user(user=nil)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user ||= FactoryBot.create(:user)
      sign_in user
    end
  end
end

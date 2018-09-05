require "rails_helper"
RSpec.describe PostalAddress, type: :model do
  describe "validations" do
    it {should validate_presence_of(:street)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:zip)}
    it { should belong_to :user }
  end
end

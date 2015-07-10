#
# role = Role.create!([{name: 'organizer'}])
# user = User.create!([{name: 'Wolverine', roles: role, github_handle: 'Adminis28'}])


5.times do
  FactoryGirl.create(:job_offer_details)
end


#
# role = Role.create!([{name: 'organizer'}])
# user = User.create!([{name: 'Wolverine', roles: role, github_handle: 'Adminis28'}])

#temp
user = User.first
if user
user.roles.create(name: "organizer")
end


5.times do
  cooljob = FactoryGirl.create(:job_offer_details)
end

# FactoryGirl.define do
#   #Minimal definition with attributes that require validation
#   factory :job_offer do
#     title         { FFaker::Job.title }
#     description   { FFaker::HipsterIpsum.paragraph }
#     company_name  { FFaker::Company.name }
#     contact_email { FFaker::Internet.email }
#     location      { [ FFaker::Address.city, FFaker::Address.country ].join(', ') }
#
#     #Nested details inherit from :job_offer
#     factory :job_offer_seeds_details do
#       contact_name  { FFaker::Name.name }
#       duration      { "#{[3,6,12,24].sample} months" }
#       misc_info     { FFaker::Company.bs.capitalize }
#       paid          { FFaker::Boolean.random }
#     end
#   end
# end

# contact_name  { FFaker::Name.name }
# duration      { duration: "#{[3,6,12,24].sample} months" }
# misc_info     { FFaker::Company.bs.capitalize }
# paid          { FFaker::Boolean.random }
#
#
# factory :post do
#   title "A title"
#
#   factory :approved_post do
#     approved true
#   end
# end
#
# approved_post = create(:approved_post)
# approved_post.title    # => "A title"
# approved_post.approved # => true
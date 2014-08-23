# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

role = Role.create!([{name: 'organizer'}])
<<<<<<< HEAD
user = User.create!([{name: 'Rita', roles: role, github_handle: 'Adminis28'}])
=======
user = User.create!([{name: 'Wolverine', roles: role, github_handle: 'Adminis28'}])
>>>>>>> 8f8e679e5e160c4baead33812508aaba74e885d4


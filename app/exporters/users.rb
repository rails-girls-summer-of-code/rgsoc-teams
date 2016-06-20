module Exporters
  class Users < Base

    def current_students
      students = User.with_role('student').with_team_kind(%w(sponsored voluntary)).
        where("teams.season_id" => Season.current)

      generate(students, 'User ID', 'Name', 'Email', 'Country', 'Locality', 'Address', 'T-shirt size') do |u|
        [u.id, u.name, u.email, u.country, u.location, u.postal_address, u.tshirt_size]
      end

    end
  end
end

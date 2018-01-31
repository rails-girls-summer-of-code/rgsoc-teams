# frozen_string_literal: true
module Exporters
  class Users < Base

    (2015..Date.today.year).each do |year|
      define_method "students_#{year}" do
        season = Season.find_by(name: year)
        export_for_season(season)
      end
    end

    def current_students
      export_for_season(Season.current)
    end

    private

    def export_for_season(season)
      students = User.joins(roles: :team)
        .references(:roles, :teams)
        .where('roles.name' => 'student')
        .where('teams.kind' => %w(sponsored deprecated_voluntary))
        .where('teams.season_id' => season)

      generate(students, 'User ID', 'Name', 'Email', 'Country', 'Locality', 'Address', 'T-shirt size', 'T-shirt cut') do |u|
        [u.id, u.name, u.email, u.country, u.location, u.postal_address, u.tshirt_size, u.tshirt_cut]
      end
    end

  end
end

module Exporters
  class Users < Base

    def current_students
      export_for_season(Season.current)
    end

    def respond_to_missing?(meth, *)
      !!(meth.to_s =~ %r(\Astudents_\d{4}\z))
    end

    def method_missing(meth, *args, &block)
      if matches = %r(\Astudents_(?<year>\d{4})\z).match(meth.to_s)
        season = Season.find_by(name: matches[:year])
        export_for_season(season)
      else
        super
      end
    end

    private

    def export_for_season(season)
      students = User.with_role('student').with_team_kind(%w(sponsored voluntary)).
        where("teams.season_id" => season)

      generate(students, 'User ID', 'Name', 'Email', 'Country', 'Locality', 'Address', 'T-shirt size') do |u|
        [u.id, u.name, u.email, u.country, u.location, u.postal_address, u.tshirt_size]
      end
    end

  end
end

class AddNamesToExistingTeams < ActiveRecord::Migration[5.0]
  class Team < ActiveRecord::Base
    self.table_name = 'teams'
  end

  def up
    Team.where("name IS NULL OR name = ''").each do |team|
      team.update_attribute :name, "<unnamed #{team.number}>"
    end
  end

  def down
  end
end

class AddConfirmationTokenToRoles < ActiveRecord::Migration
  def up
    add_column :roles, :confirmation_token, :string
    Role.joins(team: :season).where("seasons.name IN (?)", %w(2014 2015)).
      where(name: 'coach').references(:seasons).update_all(state: 'confirmed')
  end

  def down
    remove_column :roles, :confirmation_token
  end
end

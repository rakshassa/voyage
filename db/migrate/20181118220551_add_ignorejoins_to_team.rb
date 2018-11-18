class AddIgnorejoinsToTeam < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :ignorejoins, :boolean, :default => false
  end
end

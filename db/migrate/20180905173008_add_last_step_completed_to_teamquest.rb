class AddLastStepCompletedToTeamquest < ActiveRecord::Migration[5.2]
  def change
    add_column :teamquests, :last_step_completed, :integer
  end
end

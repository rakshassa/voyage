class AddIndexToPrereqs < ActiveRecord::Migration[5.2]
  def change
    add_index :prereqs, [:quest_id, :required_quest_id], unique: true
  end
end

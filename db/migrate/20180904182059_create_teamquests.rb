class CreateTeamquests < ActiveRecord::Migration[5.2]
  def change
    create_table :teamquests do |t|
      t.integer :team_id, :null => false
      t.integer :quest_id, :null => false
      t.integer :quest_status, :null => false
      t.string :answer_seed, :null => false, :limit => 25

      t.timestamps
    end

    add_index :teamquests, [:quest_id, :team_id], unique: true
  end
end

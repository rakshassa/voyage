class CreateJoinrequests < ActiveRecord::Migration[5.2]
  def change
    create_table :joinrequests do |t|
      t.integer :user_id, :null => false
      t.integer :team_id, :null => false
      t.timestamps
    end

    add_index :joinrequests, [:user_id, :team_id], unique: true
  end
end

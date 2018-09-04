class CreateQuests < ActiveRecord::Migration[5.2]
  def change
    create_table :quests do |t|
      t.string :name, :limit => 25, :null => false
      t.timestamps
    end

    add_index :quests, :name, unique: true
  end
end

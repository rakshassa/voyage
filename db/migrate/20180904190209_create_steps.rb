class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.integer :step_number, :null => false
      t.integer :points, :null => false
      t.string :name, :null => false, :limit => 50
      t.integer :quest_id, :null => false

      t.timestamps
    end

    add_index :steps, [:quest_id, :step_number], unique: true
  end
end

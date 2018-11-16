class CreatePrereqs < ActiveRecord::Migration[5.2]
  def change
    create_table :prereqs do |t|
      t.references :quest, foreign_key: true
      t.integer :required_quest_id

      t.timestamps
    end
  end
end

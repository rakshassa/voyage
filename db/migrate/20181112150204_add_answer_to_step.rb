class AddAnswerToStep < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :answer, :string, :limit => 50, :null => false, :default => "empty"
    add_column :steps, :body, :string, :limit => 300, :null => false, :default => "empty"
  end
end

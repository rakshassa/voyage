class AddAwsfieldsToTeam < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :keypair_name, :string, :limit => 100, :null => true
    add_column :teams, :keypair_filename, :string, :limit => 250, :null => true
    add_column :teams, :bucket_name, :string, :limit => 100, :null => true
    add_column :teams, :stack_name, :string, :limit => 100, :null => true
  end
end

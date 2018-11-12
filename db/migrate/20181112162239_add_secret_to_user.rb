class AddSecretToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :secret, :string, :null => true
    add_column :users, :salt, :string, :null => true
  end
end

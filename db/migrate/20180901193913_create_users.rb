class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :handle, :limit => 15, :null => true
      t.integer :team_id, :null => true

      t.timestamps
    end

    add_index :users, :handle, unique: true
  end
end

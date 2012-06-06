class AddUserTimestamps < ActiveRecord::Migration
  def up
      add_column  :users,  :created_at,  :timestamp
      add_column  :users,  :updated_at,  :timestamp
  end

  def down
      remove_column :users, :created_at
      remove_column :users, :updated_at
  end
end

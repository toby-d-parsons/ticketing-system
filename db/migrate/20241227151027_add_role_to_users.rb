class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :role, foreign_key: true
  end
end
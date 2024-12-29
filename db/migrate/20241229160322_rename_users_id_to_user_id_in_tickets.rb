class RenameUsersIdToUserIdInTickets < ActiveRecord::Migration[8.0]
  def change
    rename_column :tickets, :users_id, :user_id
  end
end

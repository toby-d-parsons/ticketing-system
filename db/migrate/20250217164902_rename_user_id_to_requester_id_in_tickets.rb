class RenameUserIdToRequesterIdInTickets < ActiveRecord::Migration[8.0]
  def change
    rename_column :tickets, :user_id, :requester_id
  end
end

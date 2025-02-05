class AddUserToTicket < ActiveRecord::Migration[8.0]
  def change
    add_reference :tickets, :assigned_agent, foreign_key: { to_table: :users }
  end
end

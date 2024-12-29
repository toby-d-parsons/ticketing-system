class AddUsersReferenceToTickets < ActiveRecord::Migration[8.0]
  def change
    add_reference :tickets, :users, foreign_key: true
  end
end

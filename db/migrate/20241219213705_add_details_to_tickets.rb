class AddDetailsToTickets < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :description, :string
    add_column :tickets, :status, :string
  end
end

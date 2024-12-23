class ChangeStatusToReference < ActiveRecord::Migration[8.0]
  def change
    remove_column :tickets, :status, :string
    add_reference :tickets, :status, foreign_key: true
  end
end

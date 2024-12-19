class ChangeDescriptionTypeInTickets < ActiveRecord::Migration[8.0]
  def change
    change_column :tickets, :description, :text
  end
end

class ChangeAssignedAgentIdNullableInTickets < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tickets, :assigned_agent_id, true
  end
end

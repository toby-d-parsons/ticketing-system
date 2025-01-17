class UserPolicy
  def initialize
    @user = Current.user
  end

  def is_admin?
    @user.role_id == 1 # Admin
  end

  def is_agent?
    @user.role_id == 2 # Support Agent
  end

  def can_access_admin_portal?
    self.is_admin?
  end

  def is_ticket_owner?(ticket)
    @user.id === ticket.user_id
  end

  def can_access_ticket?(ticket)
    global_ticket_scope? || is_ticket_owner?(ticket)
  end

  def global_ticket_scope?
    is_admin? || is_agent?
  end
end

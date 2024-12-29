class UserPolicy
  def initialize
    @user = Current.user
  end

  def is_admin?
    @user.role_id == 1 # Admin
  end

  def is_agent?
    @user.role == 2 # Support Agent
  end

  def can_access_admin_portal?
    self.is_admin?
  end
end

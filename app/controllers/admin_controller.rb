class AdminController < ApplicationController
  before_action :authorized?
  def index
  end

  private
  def authorized?
    unless ::UserPolicy.new.can_access_admin_portal?
      render file: "public/404.html", status: :unauthorized
    end
  end
end

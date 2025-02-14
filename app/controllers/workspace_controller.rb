class WorkspaceController < ApplicationController
  before_action :workspace_access?
  def index
  end

  def workspace_access?
    unless UserPolicy.new.global_ticket_scope?
      render file: "public/404.html", status: :forbidden
    end
  end
end

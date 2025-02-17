class Workspace::TicketsController < WorkspaceController
  before_action :set_ticket, only: %i[ edit update destroy ]
  before_action :load_available_statuses
  before_action :load_available_requesters, only: %i[ new create edit update ]
  before_action :set_status, only: %i[ edit update ]
  before_action :require_admin, only: :destroy
  def index
    @tickets = Ticket.all
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)

    if @ticket.save
      redirect_to workspace_tickets_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @comments = @ticket.comments.all.includes(:user)
    @comment = @ticket.comments.build
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to workspace_tickets_path
    else
      @comments = @ticket.comments.all.includes(:user)
      @comment = @ticket.comments.build
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket.destroy
    redirect_to workspace_tickets_path
  end

  private
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def load_available_statuses
    @statuses = Status.all
  end

  def load_available_requesters
    @requesters = User.all
  end

  def set_status
    @status = @ticket.status.name
  end

  def ticket_params
      params.expect(ticket: [ :title, :description, :status_id, :assigned_agent_id, :requester_id ])
  end

  def require_admin
    unless ::UserPolicy.new.is_admin?
      render file: "public/404.html", status: :forbidden
    end
  end
end

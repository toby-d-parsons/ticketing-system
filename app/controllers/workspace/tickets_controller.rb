class Workspace::TicketsController < WorkspaceController
  before_action :set_ticket, only: %i[ edit update ]
  before_action :load_available_statuses
  before_action :set_status, only: %i[ edit update ]
  def index
    @tickets = Ticket.all
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user_id = Current.user.id

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

  private
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def load_available_statuses
    @statuses = Status.all
  end

  def set_status
    @status = @ticket.status.name
  end

  def ticket_params
      params.expect(ticket: [ :title, :description, :status_id, :assigned_agent_id ])
  end
end

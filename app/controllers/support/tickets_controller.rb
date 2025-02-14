class Support::TicketsController < SupportController
  before_action :require_authentication
  before_action :set_ticket, only: %i[ show edit update ]
  before_action :authorize_ticket_access, only: %i[ show edit update ]

  def index
    @tickets = Ticket.where(user_id: Current.user.id)
  end

  def show
    @ticket = Ticket.find(params[:id])
    @comments = @ticket.comments.all.includes(:user)
    @comment = @ticket.comments.build
  end

  def new
    @ticket = Ticket.new
  end

  def edit
  end

  def update
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.status_id = Status.find_by(name: "Open").id
    @ticket.user_id = Current.user.id

    if @ticket.save
      redirect_to support_tickets_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def authorize_ticket_access
    unless UserPolicy.new.can_access_ticket?(@ticket)
      render file: "public/404.html", status: :forbidden
    end
  end

  def ticket_params
    params.expect(ticket: [ :title, :description ])
  end
end

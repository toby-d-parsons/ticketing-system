class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[ show edit update destroy ]
  before_action :load_available_statuses
  before_action :set_status, only: %i[ show edit update destroy ]
  before_action :authorize_ticket_access, only: %i[ show edit update destroy ]

  def index
    @tickets = can_view_all_tickets? ? Ticket.all : Ticket.where(user_id: Current.user.id)
  end

  def show
    @comments = @ticket.comments.all.includes(:user)
    @comment = @ticket.comments.build
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params.except(:assigned_agent_id))
    @ticket.user_id = Current.user.id
    if @ticket.save
      redirect_to @ticket
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to @ticket
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket.destroy
    redirect_to tickets_path
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
      if action_name == "update"
        params.expect(ticket: [ :title, :description, :status_id, :assigned_agent_id ])
      else
        params.expect(ticket: [ :title, :description, :status_id ])
      end
    end

    def authorize_ticket_access
      unless UserPolicy.new.can_access_ticket?(@ticket)
        render file: "public/404.html", status: :forbidden
      end
    end

    def can_view_all_tickets?
      UserPolicy.new.global_ticket_scope?
    end
end

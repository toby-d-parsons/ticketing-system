class TicketsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  before_action :set_ticket, only: %i[ show edit update destroy ]
  before_action :load_available_statuses
  before_action :set_status, only: %i[ show edit update destroy ]

  def index
    @tickets = Ticket.all
  end

  def show
    @comments = @ticket.comments.all
    @comment = @ticket.comments.build
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
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
      params.expect(ticket: [ :title, :description, :status_id ])
    end
end

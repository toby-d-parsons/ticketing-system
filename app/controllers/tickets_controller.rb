class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[ show edit update destroy ]

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

    def ticket_params
      params.expect(ticket: [ :title, :description, :status ])
    end
end

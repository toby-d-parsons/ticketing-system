class Support::CommentsController < SupportController
  before_action :require_authentication
  before_action :set_ticket, only: %i[ create ]
  before_action :authorize_access, only: %i[ create ]

  def create
    @comment = @ticket.comments.build(comment_params)
    @comment.user_id = Current.user.id

    if @comment.save
      redirect_to support_ticket_path(@ticket), notice: "Comment successfully added."
    else
      @comments = @ticket.comments
      redirect_to support_ticket_path(@ticket), status: :unprocessable_entity
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def authorize_access
    unless UserPolicy.new.can_access_ticket?(@ticket)
      render file: "public/404.html", status: :forbidden
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end

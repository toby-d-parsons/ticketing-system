class CommentsController < ApplicationController
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params)

    if @comment.save
      redirect_to @ticket, notice: "Comment successfully added."
    else
      @comments = @ticket.comments
      render "tickets/show", status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end

class CommentsController < ApplicationController
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params)
    @comment.user_id = Current.user.id

    if @comment.save
      redirect_to @ticket, notice: "Comment successfully added."
    else
      @comments = @ticket.comments
      redirect_to "/tickets/show", status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end

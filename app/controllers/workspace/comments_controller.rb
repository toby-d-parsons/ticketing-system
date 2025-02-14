class Workspace::CommentsController < WorkspaceController
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params)
    @comment.user_id = Current.user.id

    if @comment.save
      redirect_to workspace_ticket_path(@ticket), notice: "Comment successfully added."
    else
      @comments = @ticket.comments
      redirect_to workspace_ticket_path(@ticket), status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end

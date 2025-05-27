class Workspace::CommentsController < WorkspaceController
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(comment_params)
    @comment.user_id = Current.user.id

    if @comment.save
      respond_to do |format|
          format.html { redirect_to edit_workspace_ticket_path(@ticket), notice: "Post was successfully created." }
          format.turbo_stream
      end
      TicketMailer.agent_replied(@ticket).deliver
    else
      @comments = @ticket.comments
      redirect_to edit_workspace_ticket_path(@ticket), status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end

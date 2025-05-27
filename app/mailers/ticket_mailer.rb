class TicketMailer < ApplicationMailer
  default from: "me@mydomain.com"

  def registration_confirmation(user)
    @user = user
    mail(to: "<#{user.email_address}>", subject: "Registration Confirmation")
  end

  def agent_replied(ticket)
    @ticket = ticket
    @requester = User.find(@ticket.requester_id)
    mail(to: "<#{@requester.email_address}>", subject: "Your ticket has been updated")
  end

  def requester_replied(ticket)
    @ticket = ticket
    @agent = User.find(@ticket.assigned_agent_id)
    mail(to: @agent.email_address, subject: "An assigned ticket has been updated")
  end
end

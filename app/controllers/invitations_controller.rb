class InvitationsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html

  def index
    if current_user.team == nil
      @sent = current_user.invitations.select{|inv| inv.invitation == false}
      @received_unread = current_user.invitations.select{|inv| inv.invitation and inv.read == false}
      @received = current_user.invitations.select{|inv| inv.invitation and inv.read}
    else
      @sent = current_user.team.invitations.select{|inv| inv.invitation}
      @received_unread = current_user.team.invitations.select{|inv| inv.invitation == false and inv.read == false}
      @received = current_user.team.invitations.select{|inv| inv.invitation == false and inv.read}
    end
    for unread in @received_unread
      unread.read = true
      unread.save
    end
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if current_user.team == nil
      @invitation.invitation = false
      notice = 'Pomyślnie zaaplikowano do drużyny.'
    else
      @invitation.invitation = true
      notice = 'Pomyślnie zaproszono gracza do drużyny.'
    end
    @invitation.save
    redirect_to :back, notice: notice
  end

  def destroy
    invitation = Invitation.find(params[:id])
    if params[:accept] == '1'
      user = User.find(invitation.user_id)
      user.team_id = invitation.team_id
      for invitation in user.invitations
        invitation.destroy
      end
      user.save
      if current_user.team != nil and current_user.team.captain == current_user
        redirect_to :back
      else
        redirect_to team_path(user.team)
      end
    else
      invitation.destroy
      redirect_to :back
    end
  end

private
  def invitation_params
    params.permit(:user_id, :team_id)
  end
end

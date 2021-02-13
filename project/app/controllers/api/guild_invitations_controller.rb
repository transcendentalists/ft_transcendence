class Api::GuildInvitationsController < ApplicationController
  def index
    guild_invitations = GuildInvitation.for_user_index(params[:user_id])
    render :json => {
      guild_invitations: guild_invitations 
    }
  end

  def show
    render plain: "GuildInvitation show"
  end

  def create
    render plain: "GuildInvitation create"
  end

  def destroy
    render plain: "GuildInvitation destroy"
  end
end

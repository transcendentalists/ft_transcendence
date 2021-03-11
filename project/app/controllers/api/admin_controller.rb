class Api::AdminController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index ]

  def index
    return render_error :Forbidden unless current_user_is_admin_or_owner?
    user_id = @current_user.id
    begin
      resources = {
        users: User.where.not(position: "ghost").where.not(id: user_id).select(:id, :name),
        user_positions: ["web_admin", "user"],
        group_chat_rooms: GroupChatRoom.all.select(:id, :title, :channel_code),
        group_chat_memberships: GroupChatMembership.left_outer_joins(:user).select(:id, :group_chat_room_id, "users.name"),
        group_chat_positions: ApplicationRecord.group_chat_positions,
        guilds: Guild.all.select(:id, :name),
        guild_memberships: GuildMembership.left_outer_joins(:user).select(:id, :guild_id, "users.name"),
        guild_positions: ApplicationRecord.guild_positions
      }
    rescue
      return render_error :InternalServerError
    end

    render json: { db: resources }
  end
end

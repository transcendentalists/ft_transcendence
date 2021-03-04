class Api::AdminController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :index ]

  def index
    return render_error("UNAUTHORIZATION", "권한이 없습니다.", 403) unless @current_user.has_auth_for_admin_web?

    begin
      resources = {
        users: User.where.not(status: "ghost").select(:id, :name),
        group_chat_rooms: GroupChatRoom.all.select(:id, :title, :channel_code),
        group_chat_memberships: GroupChatMembership.left_outer_joins(:user).select(:id, :group_chat_room_id, "users.name"),
        group_chat_positions: ApplicationRecord.group_chat_positions,
        guilds: Guild.all.select(:id, :name),
        guild_memberships: GuildMembership.left_outer_joins(:user).select(:id, :guild_id, "users.name"),
        guild_positions: ApplicationRecord.guild_positions
      }
    rescue
      return render_error("FAILED TO LOAD RESOURCES", "관리할 데이터를 불러오는데 실패했습니다.", 500)
    end

    render json: { db: resources }
  end
end

class Api::GuildMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create, :update, :destroy ]

  def index
    guild = Guild.find_by_id(params[:guild_id])
    return render_error("길드 검색 에러", "요청하신 길드의 정보가 없습니다.", 404) if guild.nil?
    if params[:for] == "member_list"
      guild_memberships = GuildMembership.for_members_ranking(params[:guild_id], params[:page])
    end
    render json: { guild_memberships: guild_memberships }
  end

  def create
    return render_error("권한 에러", "접근 권한이 없습니다.", 401) if @current_user.id != params[:user][:id]
    return render_error('가입 실패', '해당 길드가 존재하지 않습니다.', 404) unless Guild.exists?(params[:guild_id])
    guild_membership =
      GuildMembership.create(
        user_id: params[:user][:id],
        guild_id: params[:guild_id],
        position: params[:position],
      )
    return render_error('가입 실패', '유효하지 않은 정보가 포함되어 있습니다.', 404) unless guild_membership.valid?
    @current_user.guild_invitations.destroy_all
    render json: { guild_membership: guild_membership.profile }
  end

  def update
    guild_membership = GuildMembership.find_by_id_and_guild_id(params[:id], params[:guild_id])
    return render_error('변경 실패', '길드에 존재하지 않는 멤버입니다.', 404) if guild_membership.nil?
    return render_error('권한 에러', '접근 권한이 없습니다.', 401) unless guild_membership.can_be_updated_by?(@current_user)
    guild_membership.update(position: params[:position])
    render json: { guild_membership: guild_membership.profile }
  end

  def destroy
    membership = GuildMembership.find_by_id(params[:id])
    return render_error("탈퇴 실패", "길드에 존재하지 않는 멤버입니다.", 404) if membership.nil?
    return render_error("권한 에러", "접근 권한이 없습니다.", 401) unless membership.can_be_destroyed_by?(@current_user)

    ActiveRecord::Base.transaction do
      begin
        if membership.guild.only_one_member_exist?
          membership.guild.destroy
          return head :no_content, status: 204
        end

        membership.guild.make_another_member_master! if membership.master?
        membership.destroy
        return head :no_content, status: 204
      rescue
        raise ActiveRecord::Rollback
      end
    end
    return render_error("길드멤버 제명 실패", "길드 멤버 제명에 실패했습니다.", 500)
  end
end

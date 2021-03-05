class GuildInvitationValidator < ActiveModel::Validator
  def validate(record)
    @user = User.find_by_id(record.user_id)
    @invited_user = User.find_by_id(record.invited_user_id)
    @record = record
    @record.errors.clear
    valid_of_user
    valid_of_invited_user
    @record.errors.add(:base, message: "이미 길드 초대장을 보내셨습니다.") if @invited_user&.already_received_guild_invitation_by(@user)
  end

  def valid_of_user
    if @user.nil?
      @record.errors.add(:user_id, message: "잘못된 요청입니다.")
    elsif @user.in_guild.nil?
      @record.errors.add(:user_id, message: "당신은 가입된 길드가 없습니다.")
    elsif @user.guild_membership.position == "member"
      @record.errors.add(:user_id, message: "당신은 초대 권한이 없습니다.")
    end
  end

  def valid_of_invited_user
    if @invited_user.nil?
      @record.errors.add(:invited_user_id, message: "해당 유저가 존재하지 않습니다.")
    elsif !@invited_user.in_guild.nil?
      @record.errors.add(:invited_user_id, message: "해당 유저는 가입된 길드가 있습니다.")
    end
  end
end
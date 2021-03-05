require 'rails_helper'
require 'helpers/guild_helper'

RSpec.describe Guild, type: :model do
  include GuildHelper
  it "is only_one_member_exist" do

    owner = create(:user)
    guild = create_guild({owner: owner})

    expect(guild.reload.only_one_member_exist?).to eq(true)

    officer = create_officer()
    members = create_members(3)
    expect(guild.reload.only_one_member_exist?).to eq(false)
  end

  it "can make_another_member_master" do

    owner = create(:user)
    guild = create_guild({owner: owner})

    officer = create_officer()
    members = create_members(3)

    # guild master는 a인 상태
    expect(owner.id == guild.reload.master&.user_id).to eq(true)

    guild.make_another_member_master!

    # 이제 a는 member, officer였던 b가 master가 되어야함
    expect(guild.memberships.find_by_user_id(owner.id).position).to eq("member")
    expect(officer.user_id).to eq(guild.reload.master&.user_id)

    guild.make_another_member_master!

    # 이제 a는 master, b는 member가 되어야함
    expect(guild.memberships.find_by_user_id(officer.user_id).position).to eq("member")
    expect(guild.memberships.find_by_position("master").nil?).to eq(false)
  end

  it "destroy guild if only_one_member_exist" do

    owner = create(:user)
    guild = create_guild({owner: owner})

    master = guild.memberships.find_by_user_id(owner.id)

    guild.destroy if owner.own_guild.only_one_member_exist?

    expect(guild.destroyed?).to eq(true)
    expect(GuildMembership.exists?(master.id)).to eq(false)
  end

end

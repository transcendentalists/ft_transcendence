require 'rails_helper'
require 'helpers/guild_helper'

RSpec.describe Guild, type: :model do
  include GuildHelper
  it "can make_another_member_master" do

    owner = create_user({name: "aaaa"})
    officer = create_user({name: "bbbb"})
    member1 = create_user({name: "cccc"})
    member2 = create_user({name: "dddd"})
    member3 = create_user({name: "eeee"})

    guild = create_guild({owner_id: owner.id})

    a = create_membership({user_id: owner.id, guild_id: guild.id, position: "master"})
    b = create_membership({user_id: officer.id, guild_id: guild.id, position: "officer"})
    c = create_membership({user_id: member1.id, guild_id: guild.id, position: "member"})
    d = create_membership({user_id: member2.id, guild_id: guild.id, position: "member"})
    e = create_membership({user_id: member3.id, guild_id: guild.id, position: "member"})

    expect(a.user_id == guild.reload.memberships.find_by_position("master").user_id).to eq(true)

    guild.make_another_member_master

    expect(a.user_id != guild.reload.memberships.find_by_position("master")).to eq(true)
    expect(b.user_id == guild.reload.memberships.find_by_position("master").user_id).to eq(true)

    guild.make_another_member_master

    expect(b.user_id != guild.reload.memberships.find_by_position("master").user_id).to eq(true)
    expect(a.user_id == guild.reload.memberships.find_by_position("master").user_id).to eq(true)

  end
end

require 'rails_helper'
require 'helpers/group_chat_room_helper'

RSpec.describe GroupChatRoom, type: :model do
  include GroupChatRoomHelper
  it "can let_all_out_and_destroy!" do

    owner = create(:user)
    chat_room = create_chat_room({owner: owner, register: 3})

    memberships = chat_room.memberships
    messages = chat_room.messages
    chat_room.let_all_out_and_destroy!

    expect(chat_room.persisted?).to eq(false)
    memberships.each do |membership|
      expect(ChatRoomMembership.exist?(membership.id)).to eq(false)
    end
    messages.each do |message|
      expect(ChatMessage.exist?(message.id)).to eq(false)
    end
  end

  it "owner, service_manager can_be_kicked_by?" do

    owner = create(:user)
    chat_room = create_chat_room({owner: owner, register: 3})

    web_owner = create(:user, position: "web_owner")
    web_admin = create(:user, position: "web_admin")
    member = create(:user, position: "member")
    chat_room.join(web_owner)
    chat_room.join(web_admin)
    chat_room.join(member)

    memberships = chat_room.memberships

    owner_membership = memberships.find_by_user_id(owner.id)
    web_owner_membership = memberships.find_by_user_id(web_owner.id)
    web_admin_membership = memberships.find_by_user_id(web_admin.id)
    member_membership = memberships.find_by_user_id(member.id)

    expect(owner_membership.can_be_kicked_by?(web_owner)).to eq(true)
    expect(owner_membership.can_be_kicked_by?(web_admin)).to eq(true)
    expect(owner_membership.can_be_kicked_by?(member)).to eq(false)

    expect(web_owner_membership.can_be_kicked_by?(web_owner)).to eq(true)
    expect(web_owner_membership.can_be_kicked_by?(web_admin)).to eq(true)
    expect(web_owner_membership.can_be_kicked_by?(owner)).to eq(true)
    expect(web_owner_membership.can_be_kicked_by?(member)).to eq(false)

    expect(web_admin_membership.can_be_kicked_by?(web_owner)).to eq(true)
    expect(web_admin_membership.can_be_kicked_by?(web_admin)).to eq(true)
    expect(web_admin_membership.can_be_kicked_by?(owner)).to eq(true)
    expect(web_admin_membership.can_be_kicked_by?(member)).to eq(false)

    expect(member_membership.can_be_kicked_by?(web_owner)).to eq(true)
    expect(member_membership.can_be_kicked_by?(web_admin)).to eq(true)
    expect(member_membership.can_be_kicked_by?(owner)).to eq(true)
    expect(member_membership.can_be_kicked_by?(member)).to eq(false)
  end

end

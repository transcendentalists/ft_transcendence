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

end

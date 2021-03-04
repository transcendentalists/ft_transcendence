class CreateDirectChatRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :direct_chat_rooms do |t|

      t.timestamps
    end
  end
end

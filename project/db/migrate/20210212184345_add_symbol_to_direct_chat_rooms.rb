class AddSymbolToDirectChatRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :direct_chat_rooms, :symbol, :string
  end
end

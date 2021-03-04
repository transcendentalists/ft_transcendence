class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, :polymorphic => true
      t.string :message, null: false

      t.timestamps
    end
  end
end

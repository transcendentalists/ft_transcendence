class RemoveResultFromGuildInvitations < ActiveRecord::Migration[6.1]
  def change
    remove_column :guild_invitations, :result
  end
end

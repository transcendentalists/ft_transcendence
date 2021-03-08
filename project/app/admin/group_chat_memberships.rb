ActiveAdmin.register GroupChatMembership do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :group_chat_room_id, :position, :mute, :ban_ends_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :group_chat_room_id, :position, :mute, :ban_ends_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # show do
  #   render partial: "group_chat_membership", locals: {group_chat_membership: group_chat_membership}
  # end
  
end

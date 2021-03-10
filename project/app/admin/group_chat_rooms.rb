ActiveAdmin.register GroupChatRoom do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :owner_id, :room_type, :title, :max_member_count, :current_member_count, :channel_code, :password
  #
  # or
  #
  # permit_params do
  #   permitted = [:owner_id, :room_type, :title, :max_member_count, :current_member_count, :channel_code, :password]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

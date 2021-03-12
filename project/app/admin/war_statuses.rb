ActiveAdmin.register WarStatus do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :guild_id, :war_request_id, :position, :no_reply_count, :point
  #
  # or
  #
  # permit_params do
  #   permitted = [:guild_id, :war_request_id, :position, :no_reply_count, :point]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end

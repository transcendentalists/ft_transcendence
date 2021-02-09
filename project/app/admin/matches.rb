ActiveAdmin.register Match do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :rule_id, :eventable_type, :eventable_id, :match_type, :status, :start_time, :target_score
  #
  # or
  #
  # permit_params do
  #   permitted = [:rule_id, :eventable_type, :eventable_id, :match_type, :status, :start_time, :target_score]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  show do
    render partial: 'match', locals: {match: match}
  end

  # form do |f|
  #   render partial: 'match'
  # end

end

ActiveAdmin.register WarRequest do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :rule_id, :bet_point, :start_date, :end_date, :war_time, :max_no_reply_count, :include_ladder, :include_tournament, :target_match_score, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:rule_id, :bet_point, :start_date, :end_date, :war_time, :max_no_reply_count, :include_ladder, :include_tournament, :target_match_score, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end

ActiveAdmin.register Tournament do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :rule_id, :title, :max_user_count, :start_date, :tournament_time, :incentive_title, :incentive_gift, :status, :target_match_score
  #
  # or
  #
  # permit_params do
  #   permitted = [:rule_id, :title, :max_user_count, :start_date, :tournament_time, :incentive_title, :incentive_gift, :status, :target_match_score]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  show do
    render partial: 'tournament', locals: {tournament: tournament}
  end

end

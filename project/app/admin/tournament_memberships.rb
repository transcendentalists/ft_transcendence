ActiveAdmin.register TournamentMembership do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :tournament_id, :status, :result
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :tournament_id, :status, :result]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  show do
    render partial: 'tournament_membership', locals: {tournament_membership: tournament_membership}
  end

  
end

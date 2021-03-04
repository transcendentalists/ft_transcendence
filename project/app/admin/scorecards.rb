ActiveAdmin.register Scorecard do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :match_id, :side, :score, :result
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :match_id, :side, :score, :result]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  # show do
  #   div do
  #     simple_format scorecard.side
  #     simple_format scorecard.score
  #     simple_format scorecard.result
  #   end
  # end

  show do
    render partial: 'scorecard', locals: {scorecard: scorecard}
  end

end

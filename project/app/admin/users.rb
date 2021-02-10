ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :password, :image_url, :title, :status, :two_factor_auth, :banned, :point, :email, :verification_code
  #
  # or

  show do
    render partial: 'user', locals: {user: user}
  end

  # permit_params do
  #   permitted = [:name, :password, :image_url, :title, :status, :two_factor_auth, :banned, :point, :email, :verification_code]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end

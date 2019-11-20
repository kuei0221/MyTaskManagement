class Admin::RolesController < Admin::ApplicationController
  
  #allow to change role in other role than admin
  skip_before_action :only_administrator

  def update
    if current_user.switch_role
      flash[:success] = ""
      redirect_to root_path if current_user.normal?
      redirect_to admin_root_path if current_user.administrator?
    else
      flash[:alert] = ""
      redirect_to root_path
    end
  end
  
end
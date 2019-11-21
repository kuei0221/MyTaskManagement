class Admin::RolesController < Admin::ApplicationController
  
  #allow to change role in other role than admin
  skip_before_action :only_administrator

  def update
    if current_user.switch_role
      flash[:success] = ""
    else
      flash[:alert] = ""
    end
    redirect_to root_path
  end
  
end
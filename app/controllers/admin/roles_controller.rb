class Admin::RolesController < Admin::ApplicationController
  
  #allow to change role in other role than admin
  skip_before_action :only_administrator

  def update
    if current_user.switch_role
      flash[:success] = t("admin.roles.update.success") + t("activerecord.attributes.user.role_type.#{current_user.role}")
    else
      flash[:alert] = t("admin.roles.update.alert") + t("activerecord.attributes.user.role_type.#{current_user.role}")
    end
    redirect_to root_path
  end
  
end
class Admin::ApplicationController < ApplicationController
  layout "admin"
  before_action :only_login
  before_action :only_admin
  before_action :only_administrator
  private
  def only_admin
    unless current_user.admin?
      flash[:alert] = t("controllers.only_admin_alert")
      redirect_to root_path
    end
  end

  def only_administrator
    unless current_user.administrator?
      flash[:alert] = t("controllers.only_administrator_alert")
      # ideadly, this method should only action when user is login and have admin auth but not in admin role,
      redirect_to root_path
    end
  end
end
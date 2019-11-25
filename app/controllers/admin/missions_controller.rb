class Admin::MissionsController < Admin::ApplicationController
  def index
    @missions = Mission.page params[:page]
    @user = User.find_by(id: params[:user_id]) if params[:user_id].present?
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
    @mission = Mission.find_by(id: params[:id])
    if @mission.destroy
      redirect_to admin_missions_url, notice: t("missions.destroy.success")
    else
      redirect_to admin_missions_url, alert: t("missions.destroy.fail")
    end
  end

end
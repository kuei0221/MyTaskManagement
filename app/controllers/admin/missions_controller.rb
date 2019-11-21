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
  end

end
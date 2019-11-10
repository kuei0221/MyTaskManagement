class MissionsController < ApplicationController

  def index
    @missions = Mission.order_by_created_at(:asc)
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)
    check_and_build_deadline @mission
    if @mission.save
      redirect_to root_path, notice: t("missions.create.success")
    else
      flash.now[:alert] = t("missions.create.fail")
      flash.now[:error] = @mission.errors.full_messages
      render :new
    end
  end
  
  def show
    @mission = Mission.find_by(id: params[:id])
    unless @mission
      redirect_to root_path, alert: t("missions.show.fail")
    end
  end
  
  
  def edit
    @mission = Mission.find_by(id: params[:id])
  end
  
  def update
    @mission = Mission.find_by(id: params[:id])
    check_and_build_deadline @mission
    if @mission.update(mission_params)
      redirect_to mission_path(@mission.id), notice: t("missions.update.success")
    else
      flash.now[:alert] = t("missions.update.fail")
      flash.now[:error] = @mission.errors.full_messages
      render :edit
    end
  end
  
  def destroy
    @mission = Mission.find_by(id: params[:id])
    if @mission.destroy
      redirect_to root_path, notice: t("missions.destroy.success")
    else
      redirect_back fallback_location: root_url, alert: t("missions.destroy.fail")
    end
  end

  private
  def mission_params
    params.require(:mission).permit(:name, :content, :priority)
  end

  def check_and_build_deadline(mission)
    if params.has_key?("no_deadline")
      mission.deadline = nil
    else
      mission.deadline = Date.civil(
        params[:deadline][:year].to_i,
        params[:deadline][:month].to_i,
        params[:deadline][:day].to_i)
    end
  end
  
end

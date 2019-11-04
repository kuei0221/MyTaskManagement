class MissionsController < ApplicationController

  def index
    @missions = Mission.all
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)
    if @mission.save
      redirect_to root_path, notice: t("missions.create.success")
    else
      flash.now[:alert] = t("missions.create.fail")
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
    if @mission.update(mission_params)
      redirect_to mission_path(@mission.id), notice: t("missions.update.success")
    else
      flash.now[:alert] = t("missions.update.fail")
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
    params.require(:mission).permit(:name, :content)
  end

end

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
      redirect_to root_path, notice: "Create New Mission Success!"
    else
      flash.now[:alert] = "Error Occurred when Creating New Mission"
      render :new
    end
  end
  
  def show
    @mission = Mission.find_by(id: params[:id])
    unless @mission
      redirect_to root_path, alert: "Cannot find this mission."
    end
  end
  
  
  def edit
    @mission = Mission.find_by(id: params[:id])
  end
  
  def update
    @mission = Mission.find_by(id: params[:id])
    if @mission.update(mission_params)
      redirect_to mission_path(@mission.id), notice: "Update Success!"
    else
      flash.now[:alert] = "Error Occurred when Updating Mission"
      render :edit
    end
  end
  
  def destroy
    @mission = Mission.find_by(id: params[:id])
    if @mission.destroy
      redirect_to root_path, notice: "Delete Mission Success!"
    else
      redirect_back fallback_location: root_url, alert: "Error Occurred when Deleting Mission"
    end
  end

  private
  def mission_params
    params.require(:mission).permit(:name, :content)
  end

end

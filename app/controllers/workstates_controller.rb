class WorkstatesController < ApplicationController
  before_action :only_login
  def update
    @mission = current_user.missions.find_by(id: params[:id])
    state_change_method = %w[wait progress complete].include?(params[:state]) ? params[:state] : false
    respond_to do |format|
      if @mission && state_change_method && @mission.send(state_change_method)
        format.js
      else
        format.js { render js: "alert('Errors. You cannot change work state like that.');"}
      end
    end
  end

end

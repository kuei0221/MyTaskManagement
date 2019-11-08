class SortsController < ApplicationController

  def index
    @missions = nil
    column = params["column"]
    direction = params["direction"]
    query = params["query"]["query"]
    work_state = params["query"]["work_state"]

    unless check_order_button_params
      @missions = false
    end

    if @missions.nil?
      if query.present? && work_state.present?
        @missions = Mission.search_by_state_and_name(work_state, query).order_by_column(column, direction)

      elsif query.blank? && work_state.present?
        @missions = Mission.search_by_work_state(work_state).order_by_column(column, direction)

      elsif query.present? && work_state.present?
        @missions = Mission.search_by_name(query).order_by_column(column, direction)
      else
        @missions = Mission.order_by_column(column, direction)
      end
    end

    respond_to do |format|
      if @missions
        format.js
      else
        format.js { render js: "alert(#{t('sorts.index.alert')});"}

      end
    end
  end

  private

  def check_order_button_params
    params.has_key?("direction") && 
    params.has_key?("column") && 
    Mission.attribute_names.include?(params["column"]) && 
    %w[asc desc].include?(params["direction"])
  end

end

class SearchController < ApplicationController

  def index
    if params[:query].present? && params[:work_state].present?
      @missions = Mission.search_by_state_and_name(params[:work_state], params[:query]).order_by_created_at(:asc)
    end

    if params[:query].present? && params[:work_state].blank?
      @missions = Mission.search_by_name(params[:query]).order_by_created_at(:asc)
    end

    if params[:query].blank? && params[:work_state].present?
      @missions = Mission.search_by_work_state(params[:work_state]).order_by_created_at(:asc)
    end

    if @missions.blank?
      flash.now[:alert] = t("search.index.alert")
    end

    render template: "missions/index"
  end

end

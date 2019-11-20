class SearchController < ApplicationController
  
  before_action :only_login
  def index
    @missions = Mission.filter(params).where(user_id: current_user.id )
    @missions = params[:sort].present? && params[:direction].present? ? @missions.order_by_column(params[:sort], params[:direction]) : @missions.order_by_column(:created_at, :asc)
    @missions = @missions.page(params[:page])

    if @missions.blank?
      flash.now[:alert] = t("search.index.alert")
    end

    render template: "missions/index"
  end

end

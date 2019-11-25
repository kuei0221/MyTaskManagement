class SearchController < ApplicationController
<<<<<<< HEAD
  
  before_action :only_login
  def index
    @missions = Mission.filter(params).where(user_id: current_user.id )
    @missions = params[:sort].present? && params[:direction].present? ? @missions.order_by_column(params[:sort], params[:direction]) : @missions.order_by_column(:created_at, :asc)
=======
  before_action :only_login
  def index
    sort = params[:sort]
    direction = params[:direction]
    @missions = Mission.filter(filtering_params).where(user_id: current_user.id )
    @missions = sort.present? && direction.present? ? @missions.order_by_column(sort, direction) : @missions.order_by_created_at(:asc)
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
    @missions = @missions.page(params[:page])

    if @missions.blank?
      flash.now[:alert] = t("search.index.alert")
    end

    render template: "missions/index"
  end

<<<<<<< HEAD
=======
  private

  def filtering_params
    params.slice(:name, :work_state, :priority)
  end

>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
end

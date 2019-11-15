class Admin::SearchController < Admin::ApplicationController
  
  def index
    sort = params[:sort]
    direction = params[:direction]
    @missions = Mission.filter(filtering_params).where(user_id: current_user.id )
    @missions = sort.present? && direction.present? ? @missions.order_by_column(sort, direction) : @missions.order_by_created_at(:asc)
    @missions = @missions.page(params[:page])

    if @missions.blank?
      flash.now[:alert] = t("search.index.alert")
    end

    render template: "missions/index"
  end

  private

  def filtering_params
    params.slice(:name, :work_state, :priority)
  end

end

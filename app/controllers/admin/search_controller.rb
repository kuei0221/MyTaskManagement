class Admin::SearchController < Admin::ApplicationController
  def index
    if ["Mission", "User"].include? params[:model]
      @collection = ActiveRecord.const_get params[:model]
      @collection = @collection.filter params
      @collection = params[:sort].present? && params[:direction].present? ? @collection.order_by_column(params[:sort], params[:direction]) : @collection.order_by_column(:created_at, :asc)
      @collection = @collection.page params[:page]
      case params[:model]
      when "User"
        @users = @collection
        render template: "admin/users/index"
      when "Mission"
        @missions = @collection
        @user = User.find_by(id: params[:user_id]) if params[:user_id].present?
        render template: "admin/missions/index"
      end
    else
      flash[:alert] = ""
      redirect_to admin_root_path
    end
  end

end

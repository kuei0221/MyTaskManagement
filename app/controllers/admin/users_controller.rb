class Admin::UsersController < Admin::ApplicationController

  def index
    @users = User.page params[:page]
  end

  # admin user only allow to be created by admin user or update by admin user
  def new
    @user = User.new
  end

  def create
    @user = User.new(admin_user_params)
    if @user.admin? && @user.save
      flash[:success] = t("admin.users.create.success")
      redirect_to admin_users_path
    else
      flash.now[:alert] = t("admin.users.create.alert")
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    user = User.find_by id: params[:id]
    if user && user.destroy
      flash[:success] = t("admin.users.destroy.success")
    else
      flash[:alert] = t("admin.users.destroy.alert")
    end
    redirect_to admin_users_path
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if @user && @user.update(admin_user_params)
      flash[:success] = t("admin.users.update.success")
      redirect_to admin_users_path
    else
      flash.now[:alert] = t("admin.users.update.alert")
      flash.now[:error] = @user.errors.full_messages
      render :edit
    end
  end

  private
  def admin_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

end
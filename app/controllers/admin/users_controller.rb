class Admin::UsersController < Admin::ApplicationController
  skip_before_action :only_login, :only_admin, :only_administrator, only: :test
  def index
    @users = User.page params[:page]
  end

  # admin user only allow to be created by admin user or update by admin user
  def new
    @user = User.new
  end
  
  def test
    user = User.find_by(email: "admin_testing@email.com")
    login user
    flash[:success] = t("sessions.create.success")
    redirect_to root_path
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
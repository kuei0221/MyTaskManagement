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
      flash[:success] = ""
      redirect_to admin_users_path
    else
      flash.now[:alert] = ""
      flash.now[:error] = @user.errors.full_messages
      #error if created user not admin. Should set to validation in form object when refactoring
      flash.now[:error] = "" unless @user.admin?
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    if @user 
      @missions = @user.missions.page params[:page]
    else
      flash[:alert] = ""
      redirect_to admin_users_path
    end
  end

  def destroy
    user = User.find_by id: params[:id]
    if user && user.destroy
      flash[:success] = ""
    else
      flash[:alert] = ""
    end
    redirect_to admin_users_path
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if @user && @user.update(admin_user_params)
      flash[:success] = ""
      redirect_to admin_users_path
    else
      flash.now[:alert] = ""
      flash.now[:error] = @user.errors.full_messages
      render :edit
    end
  end

  private
  def admin_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end


end
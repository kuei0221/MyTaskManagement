class UsersController < ApplicationController
  before_action :only_not_login
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login @user
      flash[:success] =  t("users.create.success")
      redirect_to root_path
    else
      flash.now[:alert] = t("users.create.alert")
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end

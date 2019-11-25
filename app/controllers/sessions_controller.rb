class SessionsController < ApplicationController
  before_action :only_not_login, only: [:new, :create]
  before_action :only_login, only: [:destroy]
  
  def new
  end
  
  def create
    user = User.find_by(email: login_params[:email])
    if user && user.authenticate(login_params[:password])
      login user
      flash[:success] = t("sessions.create.success")
      redirect_to root_path
    else
      flash.now[:alert] = t("sessions.create.alert")
      render :new
    end
  end

  def destroy
    if login?
      logout
      flash[:success] = t("sessions.destroy.success")
    else
      flash[:alert] = t("sessions.destroy.alert")
    end
    redirect_to login_path
  end

  private
  def login_params
    params.require(:session).permit(:email, :password)
  end

end

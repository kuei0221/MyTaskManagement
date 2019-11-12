class ApplicationController < ActionController::Base
  include SessionsHelper
  around_action :switch_locale
  
  def default_url_options
    { locale: I18n.locale }
  end
 
  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def only_not_login
    if login?
      flash[:alert] = t("sessions.only_not_login.alert")
      redirect_to root_path
    end
  end
  
  def only_login
    unless login?
      flash[:alert] = t("sessions.only_login.alert")
      redirect_to login_path
    end
  end

end

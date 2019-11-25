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
<<<<<<< HEAD
      flash[:alert] = t("controllers.only_not_login_alert")
=======
      flash[:alert] = t("sessions.only_not_login.alert")
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      redirect_to root_path
    end
  end
  
  def only_login
    unless login?
<<<<<<< HEAD
      flash[:alert] = t("controllers.only_login_alert")
=======
      flash[:alert] = t("sessions.only_login.alert")
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      redirect_to login_path
    end
  end

end

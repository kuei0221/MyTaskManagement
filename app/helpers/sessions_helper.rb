module SessionsHelper

  def login(user)
    session[:id] = user.id
  end

  def logout
    session.delete :id
    @current_user = nil
  end

  def login?
    session[:id].present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:id]) if login?
  end

end

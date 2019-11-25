module RolesHelper
  def is_admin?
    login? && current_user.admin?
  end

  def is_administrator?
    login? && current_user.admin? && current_user.administrator?
  end
end
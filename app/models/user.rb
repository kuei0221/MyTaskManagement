class User < ApplicationRecord
  include Filterable
  filterable %w[name email admin]
  enum role: %w[ normal administrator ]
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :password, length: {minimum: 8}, on: :create
  validates :password, length: {minimum: 8}, on: :update, if: :password_digest_changed?
  has_secure_password
  scope :search_name, ->(name){ where("NAME ILIKE ?", "%#{name}%") }
  scope :search_email, ->(email){ where("EMAIL ILIKE ?", "%#{email.downcase}%") }
  scope :search_admin, ->(boolean){ where(admin: boolean) }
  scope :order_by_created_at, ->(direction) { order(created_at: direction) }
  scope :order_by_column, ->(column, direction) { order(column => direction) }

  before_save :downcase_email
  before_destroy :cannot_destroy_last_admin
  before_update :cannot_downgrade_last_admin
  has_many :missions, dependent: :destroy

  def switch_user
    if admin?
      normal? ? administrator! : normal!
    else
      false
    end
  end

  private
  def downcase_email
    self.email = email.downcase
  end

  def cannot_downgrade_last_admin
    if admin_changed? && !admin? && self.class.search_admin(true).size == 1
      errors.add(:admin, "Cannot downgrade last admin") 
      throw :abort
    end
  end

  def cannot_destroy_last_admin
    if admin? && self.class.search_admin(true).size == 1
      errors.add(:admin, "Cannot delete last admin") 
      throw :abort
    end
  end
end

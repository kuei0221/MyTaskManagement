class User < ApplicationRecord
<<<<<<< HEAD
  include Filterable
  filterable %w[name email admin]
  enum role: %w[ normal administrator ]
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :password, length: {minimum: 8}, on: :create
  validates :password, length: {minimum: 8}, on: :update, if: :password_digest_changed?
  validate :administrator_only_for_admin
  validate :cannot_downgrade_last_admin, on: :update, if: :admin_changed?
  has_secure_password
  scope :search_name, ->(name){ where("NAME ILIKE ?", "%#{name}%") }
  scope :search_email, ->(email){ where("EMAIL ILIKE ?", "%#{email.downcase}%") }
  scope :search_admin, ->(boolean){ where(admin: boolean) }
  scope :order_by_column, ->(column, direction) { order(column => direction) }

  before_save :downcase_email
  before_destroy :cannot_destroy_last_admin
  has_many :missions, dependent: :destroy

  def switch_role
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

  def administrator_only_for_admin
    if !admin? && administrator?
      errors.add(:role, "Cannot switch to administrator for not admin account")
    end
  end

  def cannot_downgrade_last_admin
    if !admin? && self.class.search_admin(true).size == 1
      errors.add(:admin, "Cannot downgrade last admin") 
    end
  end

  def cannot_destroy_last_admin
    if admin? && self.class.search_admin(true).size == 1
      errors.add(:admin, "Cannot delete last admin") 
      throw :abort
    end
  end
=======
  has_many :missions, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :password, length: {minimum: 8}
  has_secure_password
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
end

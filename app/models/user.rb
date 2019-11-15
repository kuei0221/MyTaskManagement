class User < ApplicationRecord
  has_many :missions, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :password, length: {minimum: 8}, on: :create
  validates :password, length: {minimum: 8}, on: :update, if: :password_digest_changed?
  has_secure_password
end

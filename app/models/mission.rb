class Mission < ApplicationRecord
  default_scope {order(created_at: :asc)}

  validates :name, presence: true, length: { minimum: 8, maximum: 48 }
  validates :content, presence: true, length: {minimum: 8, maximum: 254 }
end

class Mission < ApplicationRecord
  scope :no_deadline, ->{ where("deadline is null") }
  scope :with_deadline, ->{ where("deadline is not null") }
  validates :name, presence: true, length: { minimum: 8, maximum: 48 }
  validates :content, presence: true, length: {minimum: 8, maximum: 254 }
end

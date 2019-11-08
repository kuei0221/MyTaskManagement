class Mission < ApplicationRecord
  scope :order_by_created_at, ->(direction) { order(created_at: direction) }
  scope :order_by_column, ->(column, direction) { order(column => direction) }
  scope :no_deadline, ->{ where("deadline is null") }
  scope :with_deadline, ->{ where("deadline is not null") }
  scope :search_by_work_state, ->(state) { where("work_state = ?", state) }
  scope :search_by_name,-> (name) { where("name ilike ?", "%#{name}%") }
  scope :search_by_state_and_name, ->(state, name) { where("work_state = ? and name ilike ?", state, "%#{name}%")}
  validates :name, presence: true, length: { minimum: 8, maximum: 48 }
  validates :content, presence: true, length: {minimum: 8, maximum: 254 }
  validate :datetime_before_created, on: :update
  validate :datetime_before_now
  validates :work_state, presence: true, inclusion: { in: %w[ waiting progressing completed ],
                                                      message: I18n.t("activerecord.errors.messages.mission.exist_work_state_type")}                                                      
  def waiting?
    work_state == "waiting"
  end

  def progressing?
    work_state == "progressing"
  end

  def completed?
    work_state == "completed"
  end

  def wait
    progressing? ? update(work_state: "waiting") : false
  end

  def progress
    waiting? ? update(work_state: "progressing") : false
  end

  def complete
    progressing? ? update(work_state: "completed") : false
  end

  private
  def datetime_before_created
    if deadline.present? && deadline < created_at
      errors.add(:deadline, I18n.t("activerecord.errors.messages.mission.datetime_before_created"))
    end
  end
  
  def datetime_before_now
    if deadline.present? && deadline < DateTime.now
      errors.add(:deadline, I18n.t("activerecord.errors.messages.mission.datetime_before_now"))
    end
  end
end

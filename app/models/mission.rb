class Mission < ApplicationRecord
  scope :no_deadline, ->{ where("deadline is null") }
  scope :with_deadline, ->{ where("deadline is not null") }
  validates :name, presence: true, length: { minimum: 8, maximum: 48 }
  validates :content, presence: true, length: {minimum: 8, maximum: 254 }
  validate :datetime_before_created, on: :update
  validate :datetime_before_now
  validates :work_state, presence: true, inclusion: { in: %w[ waiting progressing completed ],
                                                      message: I18n.t("activerecord.errors.messages.mission.exist_work_state_type")}                                                      
  def progress
    work_state == "waiting" ? update(work_state: "progressing") : false
  end
  
  def wait
    work_state == "progressing" ? update(work_state: "waiting") : false
  end
  
  def complete
    work_state == "progressing" ? update(work_state: "completed") : false
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

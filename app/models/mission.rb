class Mission < ApplicationRecord
  include Filterable
  filterable :name, :work_state, :priority, :user_id
  belongs_to :user, counter_cache: true
  paginates_per 10
  enum priority: %w[ low medium high ]
  enum work_state: %w[ waiting progressing completed ]
  scope :order_by_created_at, ->(direction) { order(created_at: direction) }
  scope :order_by_column, ->(column, direction) { order(column => direction) }
  scope :no_deadline, ->{ where("deadline is null") }
  scope :with_deadline, ->{ where("deadline is not null") }
  scope :search_work_state, ->(state) { where("work_state = ?", work_states.dig(state)) }
  scope :search_name,-> (name) { where("name ilike ?", "%#{name}%") }
  scope :search_priority,-> (level) { where("priority = ?", priorities.dig(level)) }
  scope :search_user_id, ->(id) { where(user_id: id)}
  validates :name, presence: true, length: { minimum: 8, maximum: 48 }
  validates :content, presence: true, length: {minimum: 8, maximum: 254 }
  validate :datetime_before_created, on: :update
  validate :datetime_before_now
  validates :work_state, presence: true, inclusion: { in: %w[ waiting progressing completed ],
                                                      message: I18n.t("activerecord.errors.messages.mission.exist_work_state_type")}
  validates :priority, presence: true, inclusion: { in: %w[ low medium high ],
                                                      message: I18n.t("activerecord.errors.messages.mission.exist_priority_level")}

  
  def wait
    progressing? ? update(work_state: "waiting") : false
  end

  def progress
    waiting? ? update(work_state: "progressing") : false
  end

  def complete
    progressing? ? update(work_state: "completed") : false
  end

  def higher_priority
    case priority
    when "low"
      medium!
    when "medium"
      high!
    else
      nil
    end
  end

  def lower_priority
    case priority
    when "high"
      medium!
    when "medium"
      low!
    else
      nil
    end
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

class AddDeadlineToMissions < ActiveRecord::Migration[6.0]
  def change
    add_column :missions, :deadline, :date, default: nil
  end
end

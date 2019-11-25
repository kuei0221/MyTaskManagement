class AddIndexOnWorkStateToMissions < ActiveRecord::Migration[6.0]
  def change
    add_index :missions, :work_state
    add_index :missions, :deadline
    add_index :missions, :name
  end
end

class AddIndexOnWorkStateToMissions < ActiveRecord::Migration[6.0]
  def change
    add_index :missions, :work_state
  end
end

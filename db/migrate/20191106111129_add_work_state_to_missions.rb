class AddWorkStateToMissions < ActiveRecord::Migration[6.0]
  def change
    add_column :missions, :work_state, :string, default: "waiting"
  end
end

class AddPriorityAndChangeDatatypeOfWorkStateToMissions < ActiveRecord::Migration[6.0]
  def change
    add_column :missions, :priority, :integer, default: 0
    add_index :missions, :priority
    change_column :missions, :work_state, :integer, using: "CASE work_state WHEN 'waiting' THEN '0'::integer WHEN 'progressing' THEN '1'::integer ELSE '2'::integer END" , default: nil
  end
end

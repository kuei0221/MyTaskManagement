class AddMissionsCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :missions_count, :integer, default: 0
  end
end

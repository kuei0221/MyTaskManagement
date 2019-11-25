class AddUserIdToMissions < ActiveRecord::Migration[6.0]
  def change
    add_reference :missions, :user, index: true
  end
end

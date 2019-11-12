class AddDefaultLimitToMissions < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :missions, :name, :string, null: false, limit: 48
        change_column :missions, :content, :text, null: false, limit: 254
      end
      
      dir.down do
        change_column :missions, :name, :string, null: true, limit: nil
        change_column :missions, :content, :text, null: true, limit: nil
      end
    end
  end
end

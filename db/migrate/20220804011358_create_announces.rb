class CreateAnnounces < ActiveRecord::Migration[6.1]
  def change
    create_table :announces do |t|
      t.integer :user_id
      t.string :announcement
      t.integer :achieve_status, default: 0

      t.timestamps
    end
  end
end

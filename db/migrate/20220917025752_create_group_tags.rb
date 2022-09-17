class CreateGroupTags < ActiveRecord::Migration[6.1]
  def change
    create_table :group_tags do |t|
      t.references :group, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class ChangeAnnouncesToAnnouncements < ActiveRecord::Migration[6.1]
  def change
    rename_table :announces, :announcements
  end
end

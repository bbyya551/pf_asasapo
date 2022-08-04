class Announcement < ApplicationRecord
  belongs_to :user

  enum achieve_status: { nonachieve: 0, achieve: 1 }
end

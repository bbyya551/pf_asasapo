class Announcement < ApplicationRecord
  belongs_to :user
  has_many :notifications, dependent: :destroy

  enum achieve_status: { nonachieve: 0, achieve: 1 }
  validates :announcement, presence: true, length: { maximum: 50 }
end

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :score, presence: true
  validates :content, length: { maximum: 50 }
end

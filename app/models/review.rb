class Review < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :score, presence: true
end

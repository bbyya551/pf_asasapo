class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reported, class_name: "User"

  validates :reason, presence:true

  enum status: { waiting: 0, keep: 1, finish: 2 }
end

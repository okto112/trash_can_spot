class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :comment, length: { in: 1..50 }
end

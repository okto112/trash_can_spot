class Kind < ApplicationRecord
  has_many :spot_kinds, dependent: :destroy
  has_many :spots, through: :spot_kinds

  validates :name, length: { in: 1..10 }
  validates :color, presence: { message: "を1つ選択してください"}
end
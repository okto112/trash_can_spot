class Kind < ApplicationRecord
  has_many :spot_kinds, dependent: :destroy
  has_many :spots, through: :spot_kinds
end
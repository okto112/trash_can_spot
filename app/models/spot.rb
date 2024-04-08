class Spot < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :spot_kinds, dependent: :destroy
  has_many :kinds, through: :spot_kinds
  belongs_to :user
end

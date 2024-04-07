class Spot < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :spot_kinds, dependent: :destroy
  belongs_to :user
end

class Spot < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :spot_kinds, dependent: :destroy
  has_many :kinds, through: :spot_kinds
  belongs_to :user

  validates :name, length: { in: 1..10 }
  validates :introduction, length: { in: 1..50 }
  validates :kind_ids, presence: { message: "を1つ以上選択してください"}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end

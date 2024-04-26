class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :spots, dependent: :destroy
  has_many :fanorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, length: { in: 1..20 }
  validates :email, presence: true

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end
end

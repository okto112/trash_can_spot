class Kind < ApplicationRecord
  has_many :spot_kinds, dependent: :destroy
end
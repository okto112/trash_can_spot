class Spot < ApplicationRecord
  enum kind: { burnable_garbage: 0, plastic: 1, pet_bottles: 2, can: 3, bottle: 4 }
end

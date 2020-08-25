class Room < ApplicationRecord
  has_many :messages, inverse_of: :room
  has_many :entries, inverse_of: :room
  has_many :users, through: :entries
end

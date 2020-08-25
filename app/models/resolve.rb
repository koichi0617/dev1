class Resolve < ApplicationRecord
  has_many :microposts, inverse_of: :resolve
end

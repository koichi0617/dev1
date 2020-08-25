class Major < ApplicationRecord
  has_many :user, inverse_of: :major
  has_many :micropost, inverse_of: :major
end

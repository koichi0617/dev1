class Major < ApplicationRecord
  has_many :user
  has_many :micropost
end

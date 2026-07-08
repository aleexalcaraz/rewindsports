class Club < ApplicationRecord
  has_many :courts
  has_many :users
end
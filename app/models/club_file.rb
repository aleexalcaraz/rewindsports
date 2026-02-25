class ClubFile < ApplicationRecord
  belongs_to :club
  has_one_attached :file
end

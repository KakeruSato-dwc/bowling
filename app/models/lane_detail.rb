class LaneDetail < ApplicationRecord
  belongs_to :reservation

  validates :name_1, presence: true
  validates :name_2, presence: true
  validates :name_3, presence: true
end


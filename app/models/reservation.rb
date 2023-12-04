class Reservation < ApplicationRecord
  belongs_to :user

  validates :group_name, presence: true
  validates :num_children, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :num_students, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :num_adults, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :num_games, presence: true
  validates :num_lanes, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true, format: {with: /[1-2][0-9]:[0-5][0-9]/}
end

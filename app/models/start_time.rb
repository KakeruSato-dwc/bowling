class StartTime < ApplicationRecord
  belongs_to :start_date

  validates :start_time, presence: true, format: {with: /[1-2][0-9]:[0-5][0-9]/}
  validates :num_available_lanes, presence: true
end

class StartDate < ApplicationRecord
  has_many :start_times, dependent: :destroy
end

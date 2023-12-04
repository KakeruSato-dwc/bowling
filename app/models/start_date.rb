class StartDate < ApplicationRecord
  has_many :start_times, dependent: :destroy
  accepts_nested_attributes_for :start_times, allow_destroy: true

  validates :start_date, presence: true
end

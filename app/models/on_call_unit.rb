class OnCallUnit < ApplicationRecord
  belongs_to :members
  belongs_to :on_call_periods

  validates :start_date, presence: true
  validates :end_date, presence: true
end

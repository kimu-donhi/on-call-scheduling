class OnCallUnit < ApplicationRecord
  belongs_to :member
  belongs_to :on_call_period

  validates :start_date, presence: true
  validates :end_date, presence: true
end

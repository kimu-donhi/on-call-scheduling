class OnCallUnit < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true

  belongs_to :member
  belongs_to :on_call_period

  validates_with DateValidator

  def to_date
    "#{start_date.strftime('%a, %d %b %Y')} ~ #{end_date.strftime('%a, %d %b %Y')}"
  end
end

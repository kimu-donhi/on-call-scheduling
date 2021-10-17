class OnCallPeriod < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :on_call_units

  validates_with DateValidator

  private

  def next_number
    last = OnCallPeriod.last.presence
    return 1 unless last.present?

    last.number + 1
  end
end

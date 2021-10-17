class OnCallPeriod < ApplicationRecord
  validates :number, presence: true, uniqueness: true, numericality: { only_integer: true }
  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :on_call_units

  validates_with DateValidator
end

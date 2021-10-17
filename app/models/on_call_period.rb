class OnCallPeriod < ApplicationRecord
  validates :number, presence: true, numericality: { only_integer: true }

  has_many :on_call_unit
end

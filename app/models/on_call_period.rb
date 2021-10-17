class OnCallPeriod < ApplicationRecord
  has_many :on_call_unit

  validates :number, presence: true, numericality: { only_integer: true }
end

class OnCallPeriod < ApplicationRecord
  validates :number, presence: true, numericality: { only_integer: true }
end

class Member < ApplicationRecord
  validates :name, presence: true

  has_many :on_call_units
end

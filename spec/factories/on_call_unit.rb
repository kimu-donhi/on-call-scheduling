FactoryBot.define do
  factory :on_call_unit, class: OnCallUnit do
    association :member
    association :on_call_period
  end
end

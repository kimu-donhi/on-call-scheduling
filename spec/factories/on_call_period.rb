FactoryBot.define do
  factory :on_call_period, class: OnCallPeriod do
    start_date { Time.current }
  end
end

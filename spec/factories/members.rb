FactoryBot.define do
  factory :member, class: Member do
    sequence(:name) { |n| "Alice Bob#{n}" }
  end
end

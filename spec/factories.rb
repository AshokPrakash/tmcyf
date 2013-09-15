require 'spec_helper'

FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.password("secret12")
    # might want to consider making this optional, having "should confirm" as 
    # an argument to the factory call
    f.confirmed_at(DateTime.now)
  end

  factory :retreat do |f|
    f.sequence(:title) { |n| "Retreat#{n}" }
    f.location("Camp")
    f.cost(100.0)
    f.sequence(:startdt) { |n| DateTime.now + n }
    f.sequence(:enddt) { |n| DateTime.now + n + 3 }
  end
end

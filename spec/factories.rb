require 'spec_helper'

FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.password("secret12")
    # might want to consider making this optional, having "should confirm" as 
    # an argument to the factory call
    f.confirmed_at(DateTime.now)
  end
end

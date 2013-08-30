class Payment < ActiveRecord::Base
  belongs_to :event
  belongs_to :credit_card
  belongs_to :user
  has_one :user, through: :credit_card
end

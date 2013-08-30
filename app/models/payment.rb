class Payment < ActiveRecord::Base
  belongs_to :event
  belongs_to :credit_card
  has_one :user, through: :credit_card
end

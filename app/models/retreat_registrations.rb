class RetreatRegistrations < ActiveRecord::Base
  belongs_to :user
  belongs_to :retreat
  # what other data is needed by retreat registrations? 
end

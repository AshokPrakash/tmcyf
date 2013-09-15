class AddUserToRetreatRegistrations < ActiveRecord::Migration
  def change
    add_column :retreat_registrations, :user_id, :integer
  end
end

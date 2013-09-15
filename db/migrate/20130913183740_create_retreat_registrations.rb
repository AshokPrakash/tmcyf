class CreateRetreatRegistrations < ActiveRecord::Migration
  def change
    create_table :retreat_registrations do |t|

      t.timestamps
    end
  end
end

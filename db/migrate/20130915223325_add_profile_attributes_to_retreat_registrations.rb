class AddProfileAttributesToRetreatRegistrations < ActiveRecord::Migration
  def change
    change_table :retreat_registrations do |t|
      t.string :email
      t.string :fname
      t.string :lname
      t.string :phone
      t.string :gender
      t.date :birthday
      t.string :line1
      t.string :city
      t.string :state
      t.string :zip
      t.string :shirtsize
    end
  end
end

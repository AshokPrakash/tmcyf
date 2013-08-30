class AddPaymentsToUsers < ActiveRecord::Migration
  def change
  	change_table :payments do |t|
  		t.belongs_to :user
  	end
  end
end

class AddCostToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.decimal :cost
    end
  end
end

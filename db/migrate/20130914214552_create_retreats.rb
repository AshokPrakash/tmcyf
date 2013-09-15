class CreateRetreats < ActiveRecord::Migration
  def change
    create_table :retreats do |t|

      t.timestamps
    end
  end
end

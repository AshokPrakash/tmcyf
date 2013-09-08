class AddDuesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :dues, :boolean
  end
end

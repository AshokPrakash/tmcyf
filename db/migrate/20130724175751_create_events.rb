class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.date :date
      t.time :time
      t.text :location
			t.string :image
			t.text :body
			t.string :slug

      t.timestamps
    end
    add_index :events, :slug
  end
end

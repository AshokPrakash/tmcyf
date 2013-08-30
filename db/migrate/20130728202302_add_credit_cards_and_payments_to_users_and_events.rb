class AddCreditCardsAndPaymentsToUsersAndEvents < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.belongs_to :user
      t.timestamps
    end
    create_table :payments do |t|
      t.belongs_to :event
      t.belongs_to :credit_card
      t.datetime :payment_date
      t.timestamps
    end
  end
end

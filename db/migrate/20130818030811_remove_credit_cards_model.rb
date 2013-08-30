class RemoveCreditCardsModel < ActiveRecord::Migration
  def change
    drop_table :credit_cards
    remove_column :payments, :credit_card_id
    add_column :users, :stripe_id, :string
    add_column :payments, :last4, :integer
  end
end

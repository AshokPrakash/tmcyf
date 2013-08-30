class AddStripeTokenToCreditCards < ActiveRecord::Migration
  def change
    change_table :credit_cards do |t|
      t.string :stripe_token
    end
  end
end

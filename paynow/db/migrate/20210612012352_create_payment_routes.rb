class CreatePaymentRoutes < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_routes do |t|
      t.belongs_to :seller_company
      t.belongs_to :payment_method_option
      t.string :token, null:false
      t.integer :bank_code
      t.string :bank_branch
      t.string :bank_account
      t.string :pix_key
      t.string :token_before_card_operator
      t.timestamps
    end
    add_index :payment_routes, :token, unique: true
  end
end

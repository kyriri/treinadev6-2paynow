class CreateChargeOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :charge_orders do |t|
      t.string :token, null:false
      t.decimal :value_before_discount, null:false
      t.decimal :value_after_discount
      t.date :due_date

      t.timestamps
    end
    add_index :charge_orders, :token, unique: true
    add_reference :charge_orders, :payment_method_option, index: true, foreign_key: true
    add_reference :charge_orders, :seller_company, index: true, foreign_key: true
    add_reference :charge_orders, :buyer, index: true, foreign_key: true
    add_reference :charge_orders, :product, index: true, foreign_key: true
  end
end

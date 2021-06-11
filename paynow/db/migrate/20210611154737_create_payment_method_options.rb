class CreatePaymentMethodOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_method_options do |t|
      t.integer :category, null: false
      t.string :provider, null: false
      t.integer :status, null: false, default: 0
      t.decimal :fee_as_percentage , null: false
      t.decimal :max_fee_in_brl, null: false, precision: 7, scale: 2

      t.timestamps
    end
  end
end

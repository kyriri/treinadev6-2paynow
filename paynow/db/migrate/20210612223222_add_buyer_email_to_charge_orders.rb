class AddBuyerEmailToChargeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :charge_orders, :buyer_email, :string
  end
end

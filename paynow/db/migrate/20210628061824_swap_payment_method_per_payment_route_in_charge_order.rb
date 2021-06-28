class SwapPaymentMethodPerPaymentRouteInChargeOrder < ActiveRecord::Migration[6.1]
  def change
    remove_reference :charge_orders, :payment_method_option, index: true, foreign_key: true
    add_reference    :charge_orders, :payment_route,         index: true, foreign_key: true
  end
end

class ChargeOrder < ApplicationRecord
  has_secure_token

  validates :due_date, :value_before_discount, :payment_method_option_id,
            :buyer_id, :product_id, presence: true
end

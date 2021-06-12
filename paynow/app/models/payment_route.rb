class PaymentRoute < ApplicationRecord
  belongs_to :seller_company
  belongs_to :payment_method_option
  
  has_secure_token
end

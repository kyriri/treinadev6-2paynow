class PaymentMethodOption < ApplicationRecord
  has_many :payment_routes
  has_many :seller_companies, through: :payment_routes

  enum category: { boleto: 1 }
  enum status: { inactive: 0, suspended: 2, active: 9 }

  validates :category, :provider, :status, :fee_as_percentage, :max_fee_in_brl, presence: true

end

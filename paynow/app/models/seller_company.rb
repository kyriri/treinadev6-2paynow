class SellerCompany < ApplicationRecord
  has_many :payment_routes
  has_many :payment_method_options, through: :payment_routes

  has_and_belongs_to_many :buyers
  has_secure_token

  validates :name, :formal_name, :cnpj, :billing_email, presence: true
  validates :cnpj, uniqueness: true

  enum access_status: { denied: 0, suspended: 2, pending: 5, allowed: 9 }
end

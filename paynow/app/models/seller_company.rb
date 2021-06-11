class SellerCompany < ApplicationRecord
  validates :name, :formal_name, :cnpj, :billing_email, presence: true
  validates :cnpj, uniqueness: true
  
  enum access_status: { denied: 0, suspended: 2, pending: 5, allowed: 9 }
end

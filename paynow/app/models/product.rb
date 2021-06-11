class Product < ApplicationRecord
  belongs_to :seller_company
  has_secure_token

  validates :name, :price, presence: true
  validates :price, numericality: { less_than: 100000.00 } # because decimal precision in DB is set to 7
end

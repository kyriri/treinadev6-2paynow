class Buyer < ApplicationRecord
  has_and_belongs_to_many :seller_companies
  has_secure_token

  validates :name, :cpf, presence: true
end

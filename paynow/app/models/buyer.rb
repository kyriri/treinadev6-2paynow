class Buyer < ApplicationRecord
  has_secure_token

  validates :name, :cpf, presence: true
end

class AddTokenToSellerCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :seller_companies, :token, :string, null: false
    add_index :seller_companies, :token, unique: true
  end
end

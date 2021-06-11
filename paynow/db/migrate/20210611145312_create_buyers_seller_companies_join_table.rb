class CreateBuyersSellerCompaniesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :buyers, :seller_companies do |t|
      t.index :buyer_id
      t.index :seller_company_id
    end
  end
end

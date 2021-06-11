class CreateSellerCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :seller_companies do |t|
      t.string :name
      t.string :formal_name
      t.string :cnpj
      t.string :billing_email
      t.integer :access_status, null: false, default: 5

      t.timestamps
    end
  end
end

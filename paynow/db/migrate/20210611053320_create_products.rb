class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :token, null:false
      t.string :name
      t.decimal :price, precision: 7, scale: 2
      t.belongs_to :seller_company, foreign_key: true

      t.timestamps
    end
    add_index :products, :token, unique: true
  end
end

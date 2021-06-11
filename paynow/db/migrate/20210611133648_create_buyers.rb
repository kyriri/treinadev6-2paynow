class CreateBuyers < ActiveRecord::Migration[6.1]
  def change
    create_table :buyers do |t|
      t.string :token
      t.string :cpf
      t.string :name

      t.timestamps
    end
    add_index :buyers, :token, unique: true
  end
end

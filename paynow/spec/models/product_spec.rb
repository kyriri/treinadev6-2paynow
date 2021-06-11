require 'rails_helper'

describe 'A product' do
  it 'has to have all basic fields' do
    product = Product.new

    product.valid?
    
    expect(product.errors[:name]).to_not be_empty
    expect(product.errors[:price]).to_not be_empty
  end 

  it 'has to be associated with a Seller Company' do
    product = Product.new(seller_company_id: '', name: 'Pistacchio ice-cream', price: 15)
    expect(product.save).to be_falsey
  end

  it 'maximum price is 99.999,99' do
    company = SellerCompany.create!(name: 'Yummy!Chocolates', formal_name: 'Madagascar Food Industry SARL',
                                    cnpj: '01.584.565/0001-26', billing_email: 'accountant@yummy.mg')
    product1 = Product.new(name: 'Plot of land 1', price: 99999.99, seller_company_id: company.id)
    product2 = Product.new(name: 'Plot of land 2', price: 100000.00, seller_company_id: company.id)

    expect(product1).to be_valid
    expect(product2).to_not be_valid
  end
end

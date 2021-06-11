require 'rails_helper'

describe 'A charge order' do
  it 'is created succesfully' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA',
                                    cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg',
                                         fee_as_percentage: 5, max_fee_in_brl: 1000)
    
    charge = ChargeOrder.create!(due_date: 3.days.from_now,
                                value_before_discount: product.price,
                                payment_method_option_id: payment_method.id,
                                seller_company_id: company.id, 
                                buyer_id: buyer.id, 
                                product_id: product.id,
                                )
    expect(charge).to be_valid
    expect(charge.token).to be
  end

  it 'cannot be created without mandatory fields' do
    charge = ChargeOrder.new
    charge.valid?
    expect(charge.errors[:due_date]).to_not be_empty
    expect(charge.errors[:value_before_discount]).to_not be_empty
    expect(charge.errors[:payment_method_option_id]).to_not be_empty
    expect(charge.errors[:buyer_id]).to_not be_empty
    expect(charge.errors[:product_id]).to_not be_empty

  end
end

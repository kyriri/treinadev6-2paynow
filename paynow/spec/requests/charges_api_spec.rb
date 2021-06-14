require 'rails_helper'

describe 'API receives request for creating a new charge' do
  it 'and it\'s succesful' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA',
                                    cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg',
                                                fee_as_percentage: 5, max_fee_in_brl: 1000)
    payment_route = PaymentRoute.create!(seller_company_id: company.id,
                                        payment_method_option_id: payment_method.id)

    post '/api/v1/charge_orders/', params: {
      charge_order: {
        company_token: company.token,
        client_token: buyer.token, 
        product_token: product.token,
        payment_type_token: payment_route.token,
        due_date: 3.days.from_now, # '2099-11-30'
        buyer_email: 'f.mercury@coldmail.com',
      }
    }
    expect(response).to have_http_status :created # 201
    expect(response.body).to include('charge_order_token')
  end

  it 'but company token is missing or invalid' do
    post '/api/v1/charge_orders/', params: { charge_order: { 
      company_token: '42' }
    }
    expect(response).to have_http_status :unauthorized # 401
    expect(response.body).to include('Invalid company token')
  end

  it 'but buyer token is missing' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
    payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

    post '/api/v1/charge_orders/', params: { charge_order: { 
      client_token: '', 
      company_token: company.token, product_token: product.token, payment_type_token: payment_route.token, due_date: 3.days.from_now, buyer_email: 'f.mercury@coldmail.com' }
    }
    expect(response).to have_http_status :unprocessable_entity # 422
    expect(response.body).to include('Invalid client token')
  end

  it 'but product token is missing' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
    payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

    post '/api/v1/charge_orders/', params: { charge_order: { 
      product_token: '', 
      company_token: company.token, client_token: buyer.token, payment_type_token: payment_route.token, due_date: 3.days.from_now, buyer_email: 'f.mercury@coldmail.com' }
    }
    expect(response).to have_http_status :unprocessable_entity # 422
    expect(response.body).to include('Invalid product token')
  end

  it 'but payment_route token is missing' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)

    post '/api/v1/charge_orders/', params: { charge_order: { 
      payment_type_token: '', 
      company_token: company.token, client_token: buyer.token, product_token: product.token, due_date: 3.days.from_now, buyer_email: 'f.mercury@coldmail.com' }
    }
    expect(response).to have_http_status :unprocessable_entity # 422
    expect(response.body).to include('Invalid payment_type token')
  end

  it 'but no due date was provided' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
    payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

    post '/api/v1/charge_orders/', params: { charge_order: { 
      due_date: nil, 
      company_token: company.token, client_token: buyer.token, product_token: product.token, payment_type_token: payment_route.token, buyer_email: 'f.mercury@coldmail.com' }
    }
    expect(response).to have_http_status :precondition_failed # 412
    expect(response.body).to include('Payment due date absent')
  end

  it 'but the provided due date is in the past' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
    payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

    post '/api/v1/charge_orders/', params: { charge_order: { 
      due_date: 1.day.ago, 
      company_token: company.token, client_token: buyer.token, product_token: product.token, payment_type_token: payment_route.token, buyer_email: 'f.mercury@coldmail.com' }
    }
    expect(response).to have_http_status :unprocessable_entity # 422
    expect(response.body).to include('Payment due date cannot be in the past')
  
  end

  it 'but no buyer email was provided' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
    payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

    post '/api/v1/charge_orders/', params: { charge_order: { 
      buyer_email: nil,
      company_token: company.token, client_token: buyer.token, product_token: product.token, payment_type_token: payment_route.token, due_date: 3.days.from_now }
    }
    expect(response).to have_http_status :precondition_failed # 412
    expect(response.body).to include('Costumer email absent')
  end

  it 'but the seller company doesn\'t own that product' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
    payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

    another_company = SellerCompany.create!(name: 'Northern De-Lights', formal_name: 'Bergman & Bergman Services SARL', cnpj: '84.613.860/0001-90', billing_email: 'ingmar.bergman@northern_delights.com')
    product_from_another_company = Product.create!(name: 'Svalbard in a Nutsheel winter tour', price: 5490, seller_company_id: another_company.id)

    post '/api/v1/charge_orders/', params: { charge_order: { 
      product_token: product_from_another_company.token, 
      company_token: company.token, client_token: buyer.token, payment_type_token: payment_route.token, due_date: 3.days.from_now, buyer_email: 'svalbard_bear@coldmail.com' }
    }
    expect(response).to have_http_status :unprocessable_entity # 422
    expect(response.body).to include('Invalid product token')
  end

  it 'but the payment route provided is associated with another company' do
    buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
    payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
    payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

    another_company = SellerCompany.create!(name: 'Northern De-Lights', formal_name: 'Bergman & Bergman Services SARL', cnpj: '84.613.860/0001-90', billing_email: 'ingmar.bergman@northern_delights.com')
    payment_route_associated_with_another_company = PaymentRoute.create!(seller_company_id: another_company.id, payment_method_option_id: payment_method.id)

    post '/api/v1/charge_orders/', params: { charge_order: { 
      payment_type_token: payment_route_associated_with_another_company.token,
      company_token: company.token, client_token: buyer.token, product_token: product.token, due_date: 3.days.from_now, buyer_email: 'svalbard_bear@coldmail.com' }
    }
    expect(response).to have_http_status :unprocessable_entity # 422
    expect(response.body).to include('Invalid payment_type token')
  end

  xit 'but the buyer is not a client of that company' do
  end
end
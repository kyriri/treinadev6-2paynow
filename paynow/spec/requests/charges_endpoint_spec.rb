require 'rails_helper'

describe 'API receives request for' do
  context 'creating a new charge' do
    it 'and it\'s succesful' do
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA',
                                      cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer.seller_companies << company
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg',
                                                  fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id,
                                          payment_method_option_id: payment_method.id)

      post '/api/v1/charge_orders/', params: {
        charge_order: {
          company_token: company.token,
          costumer_token: buyer.token, 
          product_token: product.token,
          payment_type_token: payment_route.token,
          due_date: 3.days.from_now, # '2099-11-30'
          buyer_email: 'f.mercury@coldmail.com',
        }
      }
      expect(response).to have_http_status :created # 201
      expect(response.content_type).to include('application/json') # TODO test for this overall
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
        costumer_token: '', 
        company_token: company.token, product_token: product.token, payment_type_token: payment_route.token, due_date: 3.days.from_now, buyer_email: 'f.mercury@coldmail.com' }
      }
      expect(response).to have_http_status :unprocessable_entity # 422
      expect(response.body).to include('Invalid costumer token')
    end

    it 'but product token is missing' do
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer.seller_companies << company
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

      post '/api/v1/charge_orders/', params: { charge_order: { 
        product_token: '', 
        company_token: company.token, costumer_token: buyer.token, payment_type_token: payment_route.token, due_date: 3.days.from_now, buyer_email: 'f.mercury@coldmail.com' }
      }
      expect(response).to have_http_status :unprocessable_entity # 422
      expect(response.body).to include('Invalid product token')
    end

    it 'but payment_route token is missing' do
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer.seller_companies << company
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)

      post '/api/v1/charge_orders/', params: { charge_order: { 
        payment_type_token: '', 
        company_token: company.token, costumer_token: buyer.token, product_token: product.token, due_date: 3.days.from_now, buyer_email: 'f.mercury@coldmail.com' }
      }
      expect(response).to have_http_status :unprocessable_entity # 422
      expect(response.body).to include('Invalid payment_type token')
    end

    it 'but no due date was provided' do
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer.seller_companies << company
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

      post '/api/v1/charge_orders/', params: { charge_order: { 
        due_date: nil, 
        company_token: company.token, costumer_token: buyer.token, product_token: product.token, payment_type_token: payment_route.token, buyer_email: 'f.mercury@coldmail.com' }
      }
      expect(response).to have_http_status :precondition_failed # 412
      expect(response.body).to include('Payment due date absent')
    end

    it 'but the provided due date is in the past' do
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer.seller_companies << company
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

      post '/api/v1/charge_orders/', params: { charge_order: { 
        due_date: 1.day.ago, 
        company_token: company.token, costumer_token: buyer.token, product_token: product.token, payment_type_token: payment_route.token, buyer_email: 'f.mercury@coldmail.com' }
      }
      expect(response).to have_http_status :unprocessable_entity # 422
      expect(response.body).to include('Payment due date cannot be in the past')
    
    end

    it 'but no buyer email was provided' do
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer.seller_companies << company
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

      post '/api/v1/charge_orders/', params: { charge_order: { 
        buyer_email: nil,
        company_token: company.token, costumer_token: buyer.token, product_token: product.token, payment_type_token: payment_route.token, due_date: 3.days.from_now }
      }
      expect(response).to have_http_status :precondition_failed # 412
      expect(response.body).to include('Costumer email absent')
    end

    it 'but the seller company doesn\'t own that product' do
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer.seller_companies << company
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

      another_company = SellerCompany.create!(name: 'Northern De-Lights', formal_name: 'Bergman & Bergman Services SARL', cnpj: '84.613.860/0001-90', billing_email: 'ingmar.bergman@northern_delights.com')
      product_from_another_company = Product.create!(name: 'Svalbard in a Nutsheel winter tour', price: 5490, seller_company_id: another_company.id)

      post '/api/v1/charge_orders/', params: { charge_order: { 
        product_token: product_from_another_company.token, 
        company_token: company.token, costumer_token: buyer.token, payment_type_token: payment_route.token, due_date: 3.days.from_now, buyer_email: 'svalbard_bear@coldmail.com' }
      }
      expect(response).to have_http_status :unprocessable_entity # 422
      expect(response.body).to include('Invalid product token')
    end

    it 'but the payment route provided is associated with another company' do
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer.seller_companies << company
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

      another_company = SellerCompany.create!(name: 'Northern De-Lights', formal_name: 'Bergman & Bergman Services SARL', cnpj: '84.613.860/0001-90', billing_email: 'ingmar.bergman@northern_delights.com')
      payment_route_associated_with_another_company = PaymentRoute.create!(seller_company_id: another_company.id, payment_method_option_id: payment_method.id)

      post '/api/v1/charge_orders/', params: { charge_order: { 
        payment_type_token: payment_route_associated_with_another_company.token,
        company_token: company.token, costumer_token: buyer.token, product_token: product.token, due_date: 3.days.from_now, buyer_email: 'svalbard_bear@coldmail.com' }
      }
      expect(response).to have_http_status :unprocessable_entity # 422
      expect(response.body).to include('Invalid payment_type token')
    end

    it 'but the buyer is not a client of that company' do
      another_company = SellerCompany.create!(name: 'Northern De-Lights', formal_name: 'Bergman & Bergman Services SARL', cnpj: '84.613.860/0001-90', billing_email: 'ingmar.bergman@northern_delights.com')
      buyer_registered_on_another_company = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      buyer_registered_on_another_company.seller_companies << another_company 
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)

      post '/api/v1/charge_orders/', params: { charge_order: { 
        costumer_token: buyer_registered_on_another_company.token, 
        company_token: company.token, product_token: product.token, payment_type_token: payment_route.token, due_date: 3.days.from_now, buyer_email: 'svalbard_bear@coldmail.com' }
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(response.body).to include('Invalid costumer token')
    end
    # TODO develop error hash object with: attribute, type, msg (on the models of the create buyer endpoint)
    # TODO give response with many errors at once, instead of a single failure
  end

  context 'listing charges from a company' do 
    it 'and it lists all of them succesfully' do
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      another_buyer = Buyer.create!(name: 'Funky Claude', cpf: '234.477.437-86')
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)
      first_charge_order = ChargeOrder.create!(due_date: 2.months.ago, value_before_discount: product.price, payment_method_option_id: payment_route.payment_method_option_id, seller_company_id: company.id, buyer_id: buyer.id, product_id: product.id, buyer_email: 'freddy@privacyphoenix.com')
      second_charge_order = ChargeOrder.create!(due_date: 3.days.from_now, value_before_discount: product.price, payment_method_option_id: payment_route.payment_method_option_id, seller_company_id: company.id, buyer_id: another_buyer.id, product_id: product.id, buyer_email: 'we_like_change@6mail.com')

      get '/api/v1/charge_orders/', params: {
        charge_order: {
          company_token: company.token,
          payment_type_token: '',
          filter_start_date: '',
          filter_end_date: '',
        }
      }
      expect(response).to have_http_status :ok # 200
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body).size).to eq(2)
      expect(JSON.parse(response.body).first['id']).to_not be
      expect(response.body).to include(first_charge_order.token)
      expect(response.body).to include(second_charge_order.token)

    end

    it 'filtered by due date span' do
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method.id)
      first_charge_order = ChargeOrder.create!(due_date: 1.month.ago, value_before_discount: product.price, payment_method_option_id: payment_route.payment_method_option_id, seller_company_id: company.id, buyer_id: buyer.id, product_id: product.id, buyer_email: 'freddy@privacyphoenix.com')
      second_charge_order = ChargeOrder.create!(due_date: 3.days.from_now, value_before_discount: product.price, payment_method_option_id: payment_route.payment_method_option_id, seller_company_id: company.id, buyer_id: buyer.id, product_id: product.id, buyer_email: 'we_like_change@6mail.com')

      get '/api/v1/charge_orders/', params: {
        charge_order: {
          company_token: company.token,
          payment_type_token: '',
          filter_start_date: 2.months.ago,
          filter_end_date: Date.current, # ex: '2021-06-28'
        }
      }
      expect(response).to have_http_status :ok # 200
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first['id']).to_not be
      expect(response.body).to include(first_charge_order.token)
      expect(response.body).to_not include(second_charge_order.token)
    end

    it 'filtered by payment type' do
      company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
      buyer = Buyer.create!(name: 'Freddie Mercury', cpf: '428.091.154-19')
      product = Product.create!(name: 'Pistacchio ice-cream', price: 15, seller_company_id: company.id)
      payment_method_1 = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg', fee_as_percentage: 5, max_fee_in_brl: 1000)
      payment_route_1 = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method_1.id)
      payment_method_2 = PaymentMethodOption.create!(category: 1, provider: 'PayFriend', fee_as_percentage: 4, max_fee_in_brl: 500)
      payment_route_2 = PaymentRoute.create!(seller_company_id: company.id, payment_method_option_id: payment_method_2.id)
      charge_order_1 = ChargeOrder.create!(due_date: 1.month.ago, value_before_discount: product.price, payment_method_option_id: payment_route_1.payment_method_option_id, seller_company_id: company.id, buyer_id: buyer.id, product_id: product.id, buyer_email: 'freddy@privacyphoenix.com')
      charge_order_2 = ChargeOrder.create!(due_date: 1.month.ago, value_before_discount: product.price, payment_method_option_id: payment_route_2.payment_method_option_id, seller_company_id: company.id, buyer_id: buyer.id, product_id: product.id, buyer_email: 'we_like_change@6mail.com')

      get '/api/v1/charge_orders/', params: {
        charge_order: {
          company_token: company.token,
          payment_type_token: payment_route_1.token,
          filter_start_date: '',
          filter_end_date: '',
        }
      }
      expect(response).to have_http_status :ok # 200
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first['id']).to_not be
      expect(response.body).to include(charge_order_1.token)
      expect(response.body).to_not include(charge_order_2.token)
    end

    it 'but company token is invalid' do
      get '/api/v1/charge_orders/', params: {
        charge_order: {
          company_token: 'ai, lantar laurie surinen',
        }
      }
      expect(response).to have_http_status :unauthorized # 401
      expect(response.body).to include('Invalid company token')
    end

    xit 'but payment route is invalid' do
    end
  end
end
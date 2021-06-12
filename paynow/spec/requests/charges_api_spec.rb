require 'rails_helper'

describe 'API receives request for' do
  context 'creating a new charge' do
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
          payment_method_token: payment_route.token,
          due_date: 3.days.from_now,
          # buyer_email_address: 'f.mercury@coldmail.com',
        }
      }
      expect(response).to have_http_status :created # 201
      expect(response.body).to include('order_token')
    end
  end
end
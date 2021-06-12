require 'rails_helper'

describe 'Payment route' do
  context 'is created' do
    it 'succesfully' do
      company = SellerCompany.create!(name: 'Yummy!Chocolates', formal_name: 'Madagascar Food Industry SARL',
                                      cnpj: '01.584.565/0001-26', billing_email: 'accountant@yummy.mg')
      method = PaymentMethodOption.create!(category: 1, provider: 'Bank of Duckburg',
                                           fee_as_percentage: 5, max_fee_in_brl: 1000)  
      payment_route = PaymentRoute.create!(seller_company_id: company.id,
                                            payment_method_option_id: method.id,
                                            bank_code: 51,
                                            bank_branch: 404,
                                            bank_account: '054.342-9',
                                            pix_key: nil,
                                            token_before_card_operator: nil,
                                          )
      expect(payment_route.token).to be
    end
  end

  # context 'with, and only with, the required parameters' do
  #   it 'for credit card' do
  #   end

  #   it 'for pix' do
  #   end

  #   it 'for boleto' do
  #   end
  # end
end

require 'rails_helper'

describe 'Company' do
  context 'registration' do
    it 'has access set to pending by default' do
      company = SellerCompany.create!(
        name: 'Yummy!Chocolates',
        formal_name: 'Madagascar Food Industry SARL',
        cnpj: '01.584.565/0001-26',
        billing_email: 'accountant@yummy.mg'
      )
      expect(company.access_status).to eq('pending')
    end

    it 'has to have all basic fields' do
      company = SellerCompany.new

      company.valid?

      expect(company.errors[:name]).to_not be_empty
      expect(company.errors[:formal_name]).to_not be_empty
      expect(company.errors[:cnpj]).to_not be_empty
      expect(company.errors[:billing_email]).to_not be_empty
    end 

    it 'has an alphanumeric token of 24 characters' do
      company = SellerCompany.create!(
        name: 'Yummy!Chocolates',
        formal_name: 'Madagascar Food Industry SARL',
        cnpj: '01.584.565/0001-26',
        billing_email: 'accountant@yummy.mg'
      )
      expect(company.token.size).to be >= 24

      # OBS default token (24 char) is stronger than requested (20 char) - since we create it for others to consume (we have the upper hand), there's no good reason to shorten it - but it can be reset later if needed
    end

    it 'cannot happen twice for the same CNPJ' do
      company1 = SellerCompany.create!(
        name: 'Yummy!Chocolates',
        formal_name: 'Madagascar Food Industry SARL',
        cnpj: '01.584.565/0001-26',
        billing_email: 'accountant@yummy.mg'
      )
      company2 = SellerCompany.new(
        name: 'Gelato Lovers',
        formal_name: 'Frida Davvero do Brasil LTDA',
        cnpj: '01.584.565/0001-26',
        billing_email: 'contabilidade@gelatolovers.com.br'
      )

      company2.valid?

      expect(company2.errors[:cnpj]).to_not be_empty
    end
  end

  context 'connection to Buyers' do
    it 'is possible' do
      company = SellerCompany.create!(name: 'Yummy!Chocolates', formal_name: 'Madagascar Food Industry SARL',
                                      cnpj: '01.584.565/0001-26', billing_email: 'accountant@yummy.mg')
      buyer = Buyer.create!(cpf: '428.091.154-19', name: 'Freddie Mercury')

      company.buyers << buyer

      expect(company.buyers[0]).to eq(buyer)
    end
  end
end

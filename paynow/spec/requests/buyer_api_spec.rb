require 'rails_helper'

describe 'API receives request for creating a new client' do
  it 'and it\'s succesful' do
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    another_company = SellerCompany.create!(name: 'Northern De-Lights', formal_name: 'Bergman & Bergman Services SARL', cnpj: '84.613.860/0001-90', billing_email: 'ingmar.bergman@northern_delights.com')

    post '/api/v1/buyers/', params: {
      new_costumer: {
        company_token: company.token,
        full_name: 'Maria Salomea Skłodowska', 
        cpf: '983.656.178-11',
      }
    }
    expect(response).to have_http_status :created
    expect(response.body).to include('costumer_token')
    expect(Buyer.count).to eq(1)
    expect(Buyer.last.seller_companies.where(name: 'Gelato Lovers')).to_not be_empty
  end

  it 'but fields are missing' do
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    
    post '/api/v1/buyers/', params: {
      new_costumer: {
        company_token: company.token,
        cpf: '',
      }
    }
    expect(response).to have_http_status :precondition_failed
    expect(response.body).to include('Cpf cannot be blank')
    expect(response.body).to include('Name cannot be blank')
  end

  it 'but company token is invalid' do
    company = SellerCompany.create!(name: 'Gelato Lovers', formal_name: 'Frida Trevisi di Leonardo LTDA', cnpj: '01.584.565/0001-26', billing_email: 'contabilidade@gelatolovers.com.br')
    
    post '/api/v1/buyers/', params: {
      new_costumer: {
        company_token: '51 - uma boa ideia',
        full_name: 'Maria Salomea Skłodowska', 
        cpf: '983.656.178-11',
      }
    }
    expect(response).to have_http_status :unauthorized
    expect(response.body).to include('Invalid company token')
  end
end
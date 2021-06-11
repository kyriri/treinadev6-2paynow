require 'rails_helper'

# OBS the original rules asked to link an user to its full name, however, names are fluid and they will generate instability on the system (if people change name on marriage, or simply ommit a middle name). Besides, if we are not checking if a certain name is connected to the declared CPF, we shouldn't take it as truth.
# TODO log buyer names provided at every interaction


describe 'Buyer' do
  it 'needs to provide a CPF' do # FIXME this means foreign people cannot use the service
    buyer = Buyer.new

    buyer.valid?
    
    expect(buyer.errors[:cpf]).to_not be_empty
    expect(buyer.errors[:name]).to_not be_empty
  end

  it 'has to be associated with at least one seller company' do
    # right now it just tests that it's possible to do `buyer.seller_companies`
    # TODO make this association to happen automatically on a system level
    company = SellerCompany.create!(name: 'Yummy!Chocolates', formal_name: 'Madagascar Food Industry SARL',
                                    cnpj: '01.584.565/0001-26', billing_email: 'accountant@yummy.mg')
    buyer = Buyer.create!(cpf: '428.091.154-19', name: 'Freddie Mercury')

    buyer.seller_companies << company

    expect(buyer.seller_companies[0].name).to eq('Yummy!Chocolates')
  end

  xit 'can be associated with multiple seller companies' do
  end

  xit 'needs to provide a valid CPF' do
  end

  xit 'name differences are allowed, but flag a security check' do
    # TODO move this test to a system folder
    # buyer1 = Buyer.new(cpf: '428.091.154-19', name: 'Freddie Mercury')
    # buyer2 = Buyer.new(cpf: '428.091.154-19', name: 'Farrokh Bulsara')

    # if buyer1 is registered on the system, and buyer2 tries to make a purchase
    # the system logs both names, and flag the purchase attempt to go to manual revision
  end
end

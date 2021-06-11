require 'rails_helper'

describe 'Payment method' do
  it 'is registered succesfully' do
    new_method = PaymentMethodOption.new(category: 1, provider: 'Bank of Duckburg',
                                         fee_as_percentage: 5, max_fee_in_brl: 1000)
    new_method.save
    expect(new_method.provider).to eq('Bank of Duckburg')
  end
    
  it 'cannot be saved without all fields filled' do
    new_method = PaymentMethodOption.new()
    new_method.valid?
    expect(new_method.errors[:category]).to_not be_empty
    expect(new_method.errors[:provider]).to_not be_empty
    expect(new_method.errors[:fee_as_percentage]).to_not be_empty
    expect(new_method.errors[:max_fee_in_brl]).to_not be_empty
    expect(new_method).to be_inactive
  end
end

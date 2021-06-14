class Api::V1::BuyersController < ActionController::API
  
  def create
    @seller_company = SellerCompany.find_by(token: buyer_params[:company_token])

    if @seller_company.nil?
      return render json: { error: 'Invalid company token' }, status: 401
    end

    @buyer = Buyer.create!(name: buyer_params[:full_name], cpf: buyer_params[:cpf])
    @buyer.seller_companies << @seller_company
    render json: { costumer_token: @buyer.token }, status: 201
  
  rescue ActiveRecord::RecordInvalid => trouble
    answer = trouble.record.errors.errors.each.with_object([]) { 
      |error, collection| 
      collection << {
        'field': error.attribute,
        'type': error.type,
        'message': "#{error.attribute.to_s.capitalize} cannot be #{error.type}"
      }
    }
    render json: answer, status: 412
  end

  private

  def buyer_params
    params
      .require(:new_costumer)
      .permit(:company_token,
              :full_name, 
              :cpf, 
             )
  end
end

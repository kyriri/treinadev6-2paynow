class Api::V1::ChargeOrdersController < ActionController::API
  
  def create
    @seller_company = SellerCompany.find_by(token: charge_params[:company_token])

    if @seller_company.nil?
      return render json: { error: 'Invalid company token' }, status: 401
    end

    @buyer = Buyer.find_by(token: charge_params[:client_token])
    @product = Product.find_by(token: charge_params[:product_token]) 
    @payment_route = PaymentRoute.find_by(token: charge_params[:payment_type_token])

    case true
    when @buyer.nil?
      return render json: { error: 'Invalid client token' }, status: 422
    when @product.nil? || @product.seller_company.id != @seller_company.id
      return render json: { error: 'Invalid product token' }, status: 422
    when @payment_route.nil? || @payment_route.seller_company_id != @seller_company.id
      return render json: { error: 'Invalid payment_type token' }, status: 422
    when charge_params[:buyer_email].nil?
      return render json: { error: 'Costumer email absent' }, status: 412
    when charge_params[:due_date].nil?
      return render json: { error: 'Payment due date absent' }, status: 412
    when Date.parse(charge_params[:due_date]) < Date.current
      return render json: { error: 'Payment due date cannot be in the past' }, status: 422
    end
    
    @new_charge_order = ChargeOrder
      .create(due_date: charge_params[:due_date],
              value_before_discount: @product.price,
              payment_method_option_id: @payment_route.payment_method_option_id,
              seller_company_id: @seller_company.id, 
              buyer_id: @buyer.id, 
              product_id: @product.id,
              buyer_email: charge_params[:buyer_email]
              )
    render json: { charge_order_token: @new_charge_order.token }, status: 201
  end

  private

  def charge_params
    params
      .require(:charge_order)
      .permit(:company_token, 
              :client_token, 
              :product_token,
              :due_date,
              :payment_type_token, 
              :buyer_email,
            )
  end
end

class Api::V1::ChargeOrdersController < ActionController::API
  
  def create
    @seller_company = SellerCompany.find_by!(token: charge_params[:company_token])
    if @seller_company then
      @buyer = Buyer.find_by!(token: charge_params[:client_token])
      @product = Product.find_by!(token: charge_params[:product_token])
      @payment_route = PaymentRoute.find_by!(token: charge_params[:payment_method_token])

      @new_charge_order = ChargeOrder
        .create(due_date: charge_params[:due_date],
                value_before_discount: @product.price,
                payment_method_option_id: @payment_route.payment_method_option_id,
                seller_company_id: @seller_company.id, 
                buyer_id: @buyer.id, 
                product_id: @product.id,
                # buyer_email_address: charge_params[:buyer_email_address]
               )
      render json: { charge_order_token: @new_charge_order.token }, status: 201
    else
    end
    
    
  end

  private

  def charge_params
    params
      .require(:charge_order)
      .permit(:company_token, 
              :client_token, 
              :product_token,
              :due_date,
              :payment_method_token, 
              :buyer_email_address,
            )
  end
end

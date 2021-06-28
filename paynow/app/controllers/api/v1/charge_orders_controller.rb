class Api::V1::ChargeOrdersController < ActionController::API
  before_action :authenticate_seller_company

  def index
    @charge_orders = ChargeOrder.where('seller_company_id = ?', @seller_company.id)

    if charge_params[:payment_type_token]
      @payment_route = PaymentRoute.find_by(token: charge_params[:payment_type_token])
      @charge_orders = @charge_orders.where('payment_route_id = ?', @payment_route.id)
    end

    if charge_params[:filter_start_date] and charge_params[:filter_end_date]
      @charge_orders = @charge_orders.where('due_date >= ?', charge_params[:filter_start_date])
      @charge_orders = @charge_orders.where('due_date <= ?', charge_params[:filter_end_date])
    end

    render json: @charge_orders.as_json(except: :id), status: 200
  end

  def create
    @buyer = Buyer.find_by(token: charge_params[:costumer_token])
    @product = Product.where("seller_company_id = ?", @seller_company.id).find_by(token: charge_params[:product_token])
    @payment_route = PaymentRoute.find_by(token: charge_params[:payment_type_token])

    case true
    when @buyer.nil? || @buyer.seller_companies.exclude?(@seller_company)
      return render json: { error: 'Invalid costumer token' }, status: 422
    when @product.nil? 
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

    # TODO treat the conditions above outside the action
    
    @new_charge_order = ChargeOrder
      .create(due_date: charge_params[:due_date],
              value_before_discount: @product.price,
              payment_route_id: @payment_route.id,
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
              :costumer_token, 
              :product_token,
              :due_date,
              :payment_type_token, 
              :buyer_email,
              :filter_start_date,
              :filter_end_date,
            )
  end

  def authenticate_seller_company
    @seller_company = SellerCompany.find_by(token: charge_params[:company_token])

    if @seller_company.nil?
      return render json: { error: 'Invalid company token' }, status: 401
    end
  end
end

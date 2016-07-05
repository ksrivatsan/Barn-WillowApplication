class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
    @fabrics = @order.order_details
    if(Time.now > (@order.created_at + 24.hours))
      @redirect_url = root_path
      @notice = "Order can't be updated because its more than 24 hours"
    else
      @redirect_url = edit_my_order_order_path(@order)
    end
    respond_to do |format|
      format.html { redirect_to @redirect_url, notice: @notice }
    end
  end

  def edit_my_order
    @order = Order.find(params["id"])
    @fabrics = Fabric.where(id: JSON.parse(@order.order_details))
    @checkout = "false"
    @url = order_path(@order)
    @method = "patch"
    @states_list = {'AL'=>"Alabama",'AK'=>"Alaska",'AZ'=>"Arizona",'AR'=>"Arkansas",'CA'=>"California",'CO'=>"Colorado",'CT'=>"Connecticut",'DE'=>"Delaware",'DC'=>"District Of Columbia",'FL'=>"Florida",'GA'=>"Georgia",'HI'=>"Hawaii",'ID'=>"Idaho",'IL'=>"Illinois",'IN'=>"Indiana",'IA'=>"Iowa",'KS'=>"Kansas",'KY'=>"Kentucky",'LA'=>"Louisiana",'ME'=>"Maine",'MD'=>"Maryland",'MA'=>"Massachusetts",'MI'=>"Michigan",'MN'=>"Minnesota",'MS'=>"Mississippi",'MO'=>"Missouri",'MT'=>"Montana",'NE'=>"Nebraska",'NV'=>"Nevada",'NH'=>"New Hampshire",'NJ'=>"New Jersey",'NM'=>"New Mexico",'NY'=>"New York",'NC'=>"North Carolina",'ND'=>"North Dakota",'OH'=>"Ohio",'OK'=>"Oklahoma",'OR'=>"Oregon",'PA'=>"Pennsylvania",'RI'=>"Rhode Island",'SC'=>"South Carolina",'SD'=>"South Dakota",'TN'=>"Tennessee",'TX'=>"Texas",'UT'=>"Utah",'VT'=>"Vermont",'VA'=>"Virginia",'WA'=>"Washington",'WV'=>"West Virginia",'WI'=>"Wisconsin",'WY'=>"Wyoming"}
    render "checkout"
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_new
    order_details = JSON.parse(params["order_details"])
    address = params["address"] + " " + params["city"] + " " + params["state"] + " " + params["country"] + " " + params["zipcode"]
    referred_by = params["referred_by"]
    name = params["firstname"] + " " +params["lastname"]
    email_address = params["email_address"]
    referred_by = params["referred_by_id"]
    unless (name.blank? && email_address.blank?)
      if (User.where(email_address: email_address).empty?)
        @user = User.new()
        @user.name =  name
        @user.email_address = email_address
        @user.free_credit = 0
        if @user.save
          @order = Order.new(name: name, email_address: email_address, shipping_address: address, order_details: order_details, referred_by: referred_by, user_id: @user.id)
        end
      else
        @order = Order.new(name: name, email_address: email_address, shipping_address: address, order_details: order_details, referred_by: referred_by, user_id: User.find_by(email_address: email_address).id)
      end
    end

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_path, notice: 'Order was successfully created.' }
      else
        format.html { redirect_to root_path, notice: 'Sorry something went wrong! Can you please plcae the order.' }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    result = @order.update_attributes(name: (params["firstname"] + " " + params["lastname"]), shipping_address: params["address"], order_details: params["order_details"])
    status = result ? "Order successfully updated!" : "Something went wrong. Order couldn't be updated"
    redirect_to root_url, notice: status
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def checkout
    @checkout = "true"
    @url = create_new_orders_path
    @method = "post"
    @states_list = {'AL'=>"Alabama",'AK'=>"Alaska",'AZ'=>"Arizona",'AR'=>"Arkansas",'CA'=>"California",'CO'=>"Colorado",'CT'=>"Connecticut",'DE'=>"Delaware",'DC'=>"District Of Columbia",'FL'=>"Florida",'GA'=>"Georgia",'HI'=>"Hawaii",'ID'=>"Idaho",'IL'=>"Illinois",'IN'=>"Indiana",'IA'=>"Iowa",'KS'=>"Kansas",'KY'=>"Kentucky",'LA'=>"Louisiana",'ME'=>"Maine",'MD'=>"Maryland",'MA'=>"Massachusetts",'MI'=>"Michigan",'MN'=>"Minnesota",'MS'=>"Mississippi",'MO'=>"Missouri",'MT'=>"Montana",'NE'=>"Nebraska",'NV'=>"Nevada",'NH'=>"New Hampshire",'NJ'=>"New Jersey",'NM'=>"New Mexico",'NY'=>"New York",'NC'=>"North Carolina",'ND'=>"North Dakota",'OH'=>"Ohio",'OK'=>"Oklahoma",'OR'=>"Oregon",'PA'=>"Pennsylvania",'RI'=>"Rhode Island",'SC'=>"South Carolina",'SD'=>"South Dakota",'TN'=>"Tennessee",'TX'=>"Texas",'UT'=>"Utah",'VT'=>"Vermont",'VA'=>"Virginia",'WA'=>"Washington",'WV'=>"West Virginia",'WI'=>"Wisconsin",'WY'=>"Wyoming"}
    @fabrics = Fabric.where(id: params["selected"])
    @referred_by_id = params["referred_by_id"]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :email_address, :shipping_address, :order_details, :referred_by)
    end
end

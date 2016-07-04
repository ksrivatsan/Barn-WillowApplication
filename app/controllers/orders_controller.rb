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
    name = params["firstname"]+params["lastname"]
    email_address = params["email_address"]
    referred_by = params["referred_by"]
    @order = Order.new(name: name, email_address: email_address, shipping_address: address, order_details: order_details, referred_by: referred_by)

    unless (name.blank? && email_address.blank?)
      if (User.where(email_address: email_address).empty?)
        @user = User.new()
        @user.name =  name
        @user.email_address = email_address
        if @user.save
          @order = Order.new(name: name, email_address: email_address, shipping_address: shipping_address, order_details: order_details, referred_by: referred_by)
        end
      else
        @order = Order.new(name: name, email_address: email_address, shipping_address: shipping_address, order_details: order_details, referred_by: referred_by)
      end
    end

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_path, notice: 'Order was successfully updated.' }
      else
        format.html { redirect_to root_path, notice: 'Sorry something went wrong! Can you please plcae the order.' }
        # checkout_orders_path(selected: order_details)
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
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
    @add_button = "none"
    @remove_button = "visible"
    @states_list = {'AL'=>"Alabama",'AK'=>"Alaska",'AZ'=>"Arizona",'AR'=>"Arkansas",'CA'=>"California",'CO'=>"Colorado",'CT'=>"Connecticut",'DE'=>"Delaware",'DC'=>"District Of Columbia",'FL'=>"Florida",'GA'=>"Georgia",'HI'=>"Hawaii",'ID'=>"Idaho",'IL'=>"Illinois",'IN'=>"Indiana",'IA'=>"Iowa",'KS'=>"Kansas",'KY'=>"Kentucky",'LA'=>"Louisiana",'ME'=>"Maine",'MD'=>"Maryland",'MA'=>"Massachusetts",'MI'=>"Michigan",'MN'=>"Minnesota",'MS'=>"Mississippi",'MO'=>"Missouri",'MT'=>"Montana",'NE'=>"Nebraska",'NV'=>"Nevada",'NH'=>"New Hampshire",'NJ'=>"New Jersey",'NM'=>"New Mexico",'NY'=>"New York",'NC'=>"North Carolina",'ND'=>"North Dakota",'OH'=>"Ohio",'OK'=>"Oklahoma",'OR'=>"Oregon",'PA'=>"Pennsylvania",'RI'=>"Rhode Island",'SC'=>"South Carolina",'SD'=>"South Dakota",'TN'=>"Tennessee",'TX'=>"Texas",'UT'=>"Utah",'VT'=>"Vermont",'VA'=>"Virginia",'WA'=>"Washington",'WV'=>"West Virginia",'WI'=>"Wisconsin",'WY'=>"Wyoming"}
    @fabrics = Fabric.where(id: params["selected"])
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

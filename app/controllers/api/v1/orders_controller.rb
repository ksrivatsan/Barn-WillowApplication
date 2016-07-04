class API::V1::OrdersController < ApplicationController

	skip_before_filter :verify_authenticity_token
	before_action :set_order, only: [:show, :edit, :update, :destroy, :referral]

	# GET /orders/1/edit
	def edit
		if(Time.now > (@order.created_at + 24.hours))
			status = ["Order can't be updated because its more than 24 hours"]
    else
      name = params["name"]
      email_address = params["email_address"]
			shipping_address = params["shipping_address"]
			order_details = params["order_details"]
			auth_token = params["auth_token"]
      
      @user = User.authenticate_user(auth_token, email_address)

			if @user
				if (@order.user_id == @user.id)
					result = @order.update_attributes(name: params["name"], shipping_address: params["shipping_address"], order_details: params["order_details"])
					status = result ? ["Order successfully updated!"] : ["Something went wrong. Order couldn't be updated"]
				else
					status = ["You can only edit your order"]
				end
			else
				status = ["User authentication failed"]
			end

			respond_to do |format|
				if result
					format.json{ render json: {
							status: status.join(".")
						}
					}
				else
					format.json{ render json: {
							status: status.join(".")
						}
					}
				end
			end
    end
	end

	# POST /orders
	# POST /orders.json
	def create
		name = params["name"]
		email_address = params["email_address"]
		shipping_address = params["shipping_address"]
		order_details = params["order_details"]
		referred_by_id = params["referred_by_id"]
		auth_token = params["auth_token"]
		@current_user = User.find_by(email_address: email_address)
		if @current_user
			check = (referred_by_id == @current_user.referral_id)
			if check
				error_message = ["Invalid referred by id. Can't use your own referral id"]
			else
				@user = User.authenticate_user(auth_token, email_address)
				@check_if_referrer_exists = User.find_by(referral_id: referred_by_id)
				if referred_by_id.blank? || @check_if_referrer_exists
					if @user
						@order = Order.new(name: name, email_address: email_address, shipping_address: shipping_address, order_details: order_details, referred_by: referred_by_id, user_id: @user.id)
					else
						error_message = ["User authentication failed"]
					end
				else
					error_message = ["Invalid referral id."]
				end
			end
		else
			error_message = ["Need to create user first"]
		end


		respond_to do |format|
			if (@order && @order.save)
				format.html { redirect_to @order, notice: 'Order was successfully created.' }
				format.json { render json: {
						url: {
							edit_link: (url_for :controller => 'orders', :action => 'edit', :id => @order.id),
							delete_link: (url_for :controller => 'orders', :action => 'delete', :id => @order.id),
							referral_link: (url_for :controller => 'orders', :action => 'referral', :id => @order.id, :referred_by => @order.user.referral_id)
						}
					}
				}
			else
				format.html { render :new }
				format.json { render json: {
						errors: error_message
					}
				}
			end
		end
	end

	# DELETE /orders/1
	# DELETE /orders/1.json
	def delete
		@order = Order.find_by(id: params["id"])
		if @order
			if(Time.now > (@order.created_at + 24.hours))
				status = "order can't be deleted because its more than 24 hours"
	    else
				email_address = params["email_address"]
				auth_token = params["auth_token"]
				@user = User.authenticate_user(auth_token, email_address)
				if (@user && (@user.id == @order.user_id))
					result = @order.delete
					status = result.nil? ? "Unable to destroy order." : "Order was successfully destroyed."
				else
					status = "You can only delete your order"
				end
				# Mailer.delay.welcome(recipient)
			end
		else
			status = "No such order exists"
		end
		respond_to do |format|
			format.json { render json: 
				{
					status: status
				}
			}
		end
	end

	def referral
		ids = JSON.parse(@order.order_details)
		@fabric_details = Fabric.where(id: ids).map{|f| f.fabric_type + " - " + f.fabric_color}
		details = {
			fabric_details: @fabric_details
		}
		respond_to do |format|
			format.json { render json: {
					order_details: details
				}
			}
		end
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

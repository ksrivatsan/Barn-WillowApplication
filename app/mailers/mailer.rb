class Mailer < ApplicationMailer
	append_view_path("#{Rails.root}/app/views/mailers")

  def welcome_email(user)
    @user = user
    mail(:to => @user.email_address, :subject => "Welcome to Barn & Willow")
  end

  def order_created(order)
  	@order = order
  	@ids = JSON.parse(@order.order_details)
  	@fabrics = Fabric.where(id: @ids).map{|f| f.fabric_type + " - " + f.fabric_color}
  	mail(:to => @order.user.email_address, :subject => "Orders has been generated and its on its way")
  end

  def hourly_report
  	query = Order.where(created_at: 1.hour.ago..Time.now)
  	@orders = query
  	unless query.empty?
  		@referral_based = query.where(used_referral: true)
  		@non_referral_based = query.where(used_referral: false)
  	else
  		@referral_based = []
  		@non_referral_based = []
  	end
  	@report_to_name = "Kaushik"
  	@report_to_email = "kauvas@mailinator.com"
  	mail(:to => @report_to_email, :subject => "Hourly report of orders generated")
  end

  def referral_used(user, friend_name)
  	@user = user
  	@friend_name = friend_name
  	mail(:to => @user.email_address, :subject => "Congrats on getting $10 for referring your friend")
  end
end

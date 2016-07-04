class Order < ActiveRecord::Base
	validates_presence_of :name, :email_address, :shipping_address, :order_details
	belongs_to :user

	after_create :after_create_tasks

	def after_create_tasks
		unless referred_by.blank?
			referrer = User.find_by(referral_id: referred_by)
		end
		if referrer
			referrer.free_credit += 10
			referrer.save
			self.update(used_referral: true)
			Mailer.delay.referral_used(referrer, self.name)
		else
			self.update(used_referral: false)
		end
		self.update(user_id: self.user.id)
		Mailer.delay.order_created(self)
	end
end

class User < ActiveRecord::Base
	validates_presence_of :name, :email_address
	validates_uniqueness_of :email_address

	has_many :orders
  
  before_create :generate_tokens, :validate_email
  after_create :send_user_credentials

  def generate_tokens
  	self.auth_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(auth_token: random_token)
    end
  	generate_referral_id
  end

  def generate_referral_id
  	self.referral_id = loop do
      random_token = 1_000_000 + Random.rand(10_000_000 - 1_000_000)
      break random_token unless User.exists?(referral_id: random_token)
    end
  end

  def validate_email
  	result = !email_address.match(/\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i).blank?
  	domain = email_address.match(/\@(.+)/)[1]
    Resolv::DNS.open do |dns|
      @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end
    ((@mx.size > 0) && result) ? true : false
  end

  def self.authenticate_user(auth_token, email_address)
  	user = User.where(auth_token: auth_token, email_address: email_address)
  	return (user.empty? ? false : true) ? user.first : nil
 	end

  def send_user_credentials
    Mailer.delay.welcome_email(self)
  end
end

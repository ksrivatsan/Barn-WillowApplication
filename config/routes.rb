Rails.application.routes.draw do

  resources :users
	namespace :api, :defaults => {:format => :json} do
		# , :path => "", :constraints => {:subdomain => "api"}
	  namespace :v1 do
	    resources :orders do
	    	collection do
  				post 'create'
	  		end
	  		member do
	  			put 'edit'
	  			delete 'delete'
	  			get 'referral'
	  		end
	  	end
	  	resources :users do
	    	collection do
					post 'create'
	  		end
		  end
	  end
	end
  
  resources :orders do
  	collection do
  		post 'checkout'
	  	post 'create_new'
	  end
  end
  resources :fabrics
  root to: 'visitors#index'
end

class ApplicationController < ActionController::Base
    def current_user
		return unless session[:user]
		@current_user ||= User.find _id: session[:_id]
	end
	protected
		def authenticate!
			if !session[:user]
				redirect_to :root
			end
		end
    
end

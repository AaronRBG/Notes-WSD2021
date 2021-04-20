class ApplicationController < ActionController::Base
	helper_method :current_user
	helper_method :logged_in?	
	
	def current_user
		if session[:username].nil?
			return nil
		end
		return unless session[:user]
		@current_user ||= User.find(session[:username])
	end

	def logged_in?
		!current_user.nil?  
	end

end

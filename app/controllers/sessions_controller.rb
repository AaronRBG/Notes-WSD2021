class SessionsController < ApplicationController

  # GET /sessions/new
  def index
    session[:_id] = "NONE"
    session[:user_id] = "NONE"
    session[:type] = "NONE"
    @session = Session.new
  end

  def read
    @session = Session.find(params[:_id])
  end
  
  def create
    @current_user = User.find(params[:username])
    if !@current_user
      flash.now.alert = "name #{params[:username]} was invalid"
      render :new
    elsif @current_user.password == params[:password]
      aux = Session.find_by(:user => @current_user.username)
      if !aux.nil?
        aux.delete
      end
      @session = Session.new(:user => @current_user.username)
      @session.save!
      session[:_id] = @session._id
      session[:user_id] = @current_user.username
      session[:type] = @current_user.type
      redirect_to '/notes'
    else
      flash.now.alert = "password was invalid"
      render :new
    end
  end

  # DELETE /sessions/1 or /sessions/1.json
  def logout
    @session = Session.find(session[:_id])
    @session.destroy
    flash.now.alert = "Logout was successful"
    session[:_id] = "NONE"
    session[:user_id] = "NONE"
    session[:type] = "NONE"
    render :new
  end

  private

    # Only allow a list of trusted parameters through.
    def session_params
      params.permit(:_id, :token, :username, :password)
    end
end
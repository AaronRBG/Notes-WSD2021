class SessionsController < ApplicationController

  # GET /sessions/new
  def new
    session[:_id] = "NONE"
    session[:user_id] = "NONE"
    session[:type] = "NONE"
    @session = Session.new
  end
  
  def create
    @current_user = User.find(params[:username])
    if !@current_user
      flash.now.alert = "name #{params[:username]} was invalid"
      redirect_to login_path
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
      if @current_user.type == "ADMIN"
        redirect_to notes_path
      else
  
  #HE CAMBIADO ESTOOOOOOOOOO antes ponia noteUser_path
        redirect_to notecollectionsUser_path(:user => @current_user.username)
      end
    else
      flash.now.alert = "password was invalid"
      redirect_to login_path
    end
  end

  # DELETE /sessions/1 or /sessions/1.json
  def logout
    if session[:_id] != "NONE"
      @session = Session.find(session[:_id])
      @session.destroy
      flash.now.alert = "Logout was successful"
      session[:_id] = "NONE"
      session[:user_id] = "NONE"
      session[:type] = "NONE"
    end
    redirect_to login_path
  end

  private

    # Only allow a list of trusted parameters through.
    def session_params
      params.permit(:_id, :token, :username, :password)
    end
end
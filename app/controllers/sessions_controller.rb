class SessionsController < ApplicationController

  # GET /sessions/new
  def index
    @session = Session.new
  end

  def read
    @session = Session.find(params[:_id])
  end
  
  def create
    @user = User.find(params[:username])
    if !@user
      flash.now.alert = "name #{params[:username]} was invalid"
      render :new
    elsif @user.password == params[:password]
      aux = Session.find_by(:user => @user.username)
      if !aux.nil?
        aux.delete
      end
      @session = Session.new(:user => @user.username)
      @session.save!
      session[:_id] = @session._id
      session[:user_id] = @user.username
      session[:type] = @user.type
      redirect_to '/notes'
    else
      flash.now.alert = "password was invalid"
      render :new
    end
  end

  # POST /sessions or /sessions.json
  def login
    @session = Session.new(session_params)

    respond_to do |format|
      if @session.save
        if(User.find(@session.user).type=="ADMIN")
          format.html { redirect_to action: "/notes", notice: "Admin login was successful." }
        else
          format.html { redirect_to action: "/notes", notice: "User login was successful." }
        end
      else
        format.html { redirect_to action: "index", notice: "Login was not successful." }
      end
    end
  end

  # DELETE /sessions/1 or /sessions/1.json
  def logout
    @session = Session.find(session[:_id])
    @session.destroy
    respond_to do |format|
        format.html { redirect_to action: "sessions", notice: "Logout was successful." }
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def session_params
      params.permit(:_id, :token, :username, :password)
    end
end
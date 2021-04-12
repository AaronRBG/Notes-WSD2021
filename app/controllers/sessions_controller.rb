class SessionsController < ApplicationController

    # GET /sessions/new
    def index
      @session = Session.new
    end
  
    def read
      @session = Session.find(params[:_id])
    end
  
    # POST /sessions or /sessions.json
    def login
      @session = Session.new(session_params)
  
      respond_to do |format|
        if @session.save
          if(User.find(@session.user).type=="ADMIN")
            format.html { redirect_to action: "users/admin", notice: "Admin login was successful." }
          else
            format.html { redirect_to action: "users/user", notice: "User login was successful." }
          end
        else
          format.html { redirect_to action: "index", notice: "Login was not successful." }
        end
      end
    end
  
    # DELETE /sessions/1 or /sessions/1.json
    def logout
      @session = Session.find(params[:_id])
      @session.destroy
      respond_to do |format|
          format.html { redirect_to action: "index", notice: "Logout was successful." }
      end
    end
  
    private
  
      # Only allow a list of trusted parameters through.
      def session_params
        params.permit(:_id, :token, :user)
      end
  end
class SessionsController < ApplicationController

    # GET /sessions/new
    def index
      @session = Session.new
    end
  
    def read
      @session = Note.find(params[:_id])
    end
  
    # POST /sessions or /sessions.json
    def login
      @session = Session.new(session_params)
  
      respond_to do |format|
        if @session.save
          if(User.find(@session.user).type=="Admin")
            format.html { redirect_to action: "users/admin", notice: "Note was successfully created." }
          else
            format.html { redirect_to action: "users/user", notice: "Note was successfully created." }
          end
        else
          format.html { redirect_to action: "index", notice: "Note was not created." }
        end
      end
    end
  
    # DELETE /sessions/1 or /sessions/1.json
    def logout
      @session = Note.find(params[:_id])
      @session.destroy
      respond_to do |format|
          format.html { redirect_to action: "index", notice: "Note was successfully created." }
      end
    end
  
    private
  
      # Only allow a list of trusted parameters through.
      def session_params
        params.require(:session).permit(:_id, :token, :user)
      end
  end
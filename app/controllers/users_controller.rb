class UsersController < ApplicationController
    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def show
      @user = User.find_by (params[:name])
      
    end

    def edit
      @user = User.find_by(params[:name])
    end

    def promote
      @user = User.find(params[:_id])
      respond_to do |format|
        if @user.update(:type => "ADMIN")
            format.html { redirect_to action: "index", notice: "User was successfully updated." }
        else
          format.html { redirect_to action: "index", notice: "User was not updated" }
        end
      end
    end

    def demote
      @user = User.find(params[:_id])
      respond_to do |format|
        if @user.update(:type => "USER")
            format.html { redirect_to action: "index", notice: "User was successfully updated." }
        else
          format.html { redirect_to action: "index", notice: "User was not updated" }
        end
      end
    end
      
    def destroy
      @user = User.find(params[:_id])
      @user.destroy
      respond_to do |format|
        #Hay que cambiar index por ruta donde esten todas los usuarios para administrar por el administrador
        format.html { redirect_to action: "view with all users", notice: "User deleted succesfully" }
        end
    end

    def create
      @user = User.new(user_params)

        if @user.save
          #User.new(@user._id)
          session[:user] = @user.id
          session[:type] = @user.type
          session[:admin] = @user.admin
          redirect_to users_path, :notice => "User was successfully created." 
        else
          redirect_to  users_path, :notice => "User was not created." 
        end
     
    end 


    def update
        aux = User.new(user_params)
        @user = User.find_by(params[:name])
        respond_to do |format|
          if @user.update(:name => aux.name, :email => aux.email, :password => aux.password)
              format.html { redirect_to action: "index", notice: "User was successfully updated." }
          else
            format.html { redirect_to action: "index", notice: "User was not updated" }
          end
        end
    end
    
    private
      # Only allow a list of trusted parameters through.
      def user_params
          params.require(:user).permit(:name, :email, :username, :password, :type)
      end
end

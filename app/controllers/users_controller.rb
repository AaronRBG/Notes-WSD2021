class UsersController < ApplicationController
    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def show
      @user = User.find(params[:_id])
    end

    def edit
      @user = User.find(params[:_id])
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
    
      respond_to do |format|
        if @user.save
          #Hay que cambiar index por ruta donde esten las notas de ese usuario
          format.html { redirect_to action: "index", notice: "User successfully created." }
        else
          #Hay que cambiar index por ruta donde esten las notas de ese usuario
          format.html { redirect_to action: "index", notice: "User was not created." }
        end
      end
    end

    def update
        aux = User.new(user_params)
        @user = User.find(aux._id)
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
          params.require(:user).permit(:_id, :name, :email, :username, :password, :type)
      end
end

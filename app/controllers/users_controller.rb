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
    @user.update(:type => "ADMIN")
    redirect_to users_path
  end

  def demote
    @user = User.find(params[:_id])
    @user.update(:type => "USER")
    redirect_to users_path
  end
      
  def destroy
    @user = User.find(params[:_id])
    #usernotes = UserNote.find_by(:user => @user.username)
    #usernotes.each do |usernote|
      #note = Note.find(usernote.note)
      #note.delete
      #usernote.delete
    #end
    @user.destroy
    redirect_to users_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user] = @user.id
      session[:type] = @user.type
    end
    redirect_to users_path
  end 

  def update
    aux = User.new(user_params)
    @user = User.find(params[:_id])
    @user.update(:name => aux.name, :email => aux.email, :password => aux.password)
    redirect_to users_path
  end
    
  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :username, :password, :type)
    end
end
class UsersController < ApplicationController
  def index
    if session[:type] == "ADMIN"
      @users = User.all
    elsif session[:type] == "USER"
      redirect_to notesUser_path(:user => session[:user_id])
    else
      redirect_to login_path
    end
  end

  def new
    if session[:type] != "USER"
      @user = User.new
    else
      redirect_to notesUser_path(:user => session[:user_id])
    end
  end

  def show
    if session[:type] == "ADMIN"
      @user = User.find(params[:_id])
    elsif session[:type] == "USER"
      redirect_to notesUser_path(:user => session[:user_id])
    else
      redirect_to login_path
    end
  end

  def edit
    if session[:type] == "ADMIN"
      @user = User.find(params[:_id])
    elsif session[:type] == "USER"
      redirect_to notesUser_path(:user => session[:user_id])
    else
      redirect_to login_path
    end
  end

  def promote
    if session[:type] == "ADMIN"
      @user = User.find(params[:_id])
      @user.update(:type => "ADMIN")
      redirect_to users_path
    elsif session[:type] == "USER"
      redirect_to notesUser_path(:user => session[:user_id])
    else
      redirect_to login_path
    end
  end

  def demote
    if session[:type] == "ADMIN"
      @user = User.find(params[:_id])
      @user.update(:type => "USER")
      redirect_to users_path
    elsif session[:type] == "USER"
      redirect_to notesUser_path(:user => session[:user_id])
    else
      redirect_to login_path
    end
  end
      
  def destroy
    if session[:type] == "ADMIN"
      @user = User.find(params[:_id])
      # DELETE NOTES ON CASCADE
      usernotes = UserNote.where(:user_id => @user.username).to_a
      usercollections = UserCollection.where(:user_id => @user.username).to_a
      i = 0
      while i < usernotes.length do
        if UserNote.where(:note_id => usernotes[i].note_id).count == 1
          note = Note.find(usernotes[i].note_id)
          note.destroy
        end
        usernotes[i].delete
        i = i+1
      end
      i = 0
      while i < usercollections.length do
        if UserCollection.where(:collection_id => usercollections[i].collection_id).count == 1
          collection = Collection.find(usercollections[i].collection_id)
          collection.delete
        end
        usercollections[i].delete
        i = i+1
      end
      @user.destroy
      redirect_to users_path
    elsif session[:type] == "USER"
      redirect_to notesUser_path(:user => session[:user_id])
    else
      redirect_to login_path
    end
  end

  def create
    if session[:type] != "USER"
      @user = User.new(user_params)
      @user.save
      if session[:type] == "ADMIN"
        redirect_to users_path
      else
        redirect_to login_path
      end
    else
      redirect_to notesUser_path(:user => session[:user_id])
    end
  end 

  def update
    if session[:type] == "ADMIN"
      aux = User.new(user_params)
      a = user_params[:username]
      @user = User.find(user_params[:username])
      a = @user
      @user.update(:name => aux.name, :email => aux.email, :password => aux.password)
      redirect_to users_path
    elsif session[:type] == "USER"
      redirect_to notesUser_path(:user => session[:user_id])
    else
      redirect_to login_path
    end
  end
    
  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :username, :password, :type)
    end
end
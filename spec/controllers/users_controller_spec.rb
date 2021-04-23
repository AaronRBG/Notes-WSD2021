require "rails_helper"

RSpec.describe UsersController, :type => :controller do
  context "UsersController" do
    subject { @user }
    before(:all) do
      @user = User.create(username: "username", name: "name", email: "email@email.com", password: "Password1", type: "USER")
      @user.save!
    end
    after(:all) do
      @user.delete
    end
    describe "GET users" do
      it "returns the login if there is no session" do
        expect(:get => "/users").to route_to("users#index")
        session[:type] = "NONE"
        get :index
        expect(response).to redirect_to login_path
      end
      it "returns the users page if the session is of type admin" do
        session[:type] = "ADMIN"
        get :index
        expect(response).to render_template("index")
      end
      it "returns the notes of the user if the session is of type user" do
        session[:type] = "USER"
        get :index
        expect(response).to redirect_to notesUser_path
      end
    end
    describe "GET show" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :show, params: { :_id => @user._id,  :id => @user._id}
        expect(response).to redirect_to login_path
      end
      it "returns the show user page if the user has access to it" do
        session[:type] = "ADMIN"
        get :show, params: { :_id => @user._id,  :id => @user._id}
        expect(response).to render_template("show")
      end
    end
    describe "GET new" do
      it "returns the notes of the user if there is a session of type 'USER'" do
        session[:type] = "USER"
        session[:user_id] = "User"
        get :new
        redirect_to notesUser_path(:user => "User")
      end
      it "returns the create new user if there is no session or a session of type 'ADMIN" do
        session[:type] = "NONE"
        get :new
        expect(response).to render_template("new")
      end
    end
    describe "POST demote" do
      it "returns the login if there is no session" do
        expect(:post => "/demote").to route_to("users#demote")
        session[:user_id] = "NONE"
        post :demote, params: { :_id => @user._id,  :id => @user._id}
        expect(response).to redirect_to login_path
      end
      it "Demotes the user type to 'USER', if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :demote, params: { :_id => @user._id,  :id => @user._id}
        expect(response).to redirect_to users_path
      end
    end
    describe "POST promote" do
      it "returns the login if there is no session" do
        expect(:post => "/promote").to route_to("users#promote")
        session[:user_id] = "NONE"
        post :promote, params: { :_id => @user._id,  :id => @user._id}
        expect(response).to redirect_to login_path
      end
      it "Promotes the user type to 'ADMIN', if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :promote, params: { :_id => @user._id,  :id => @user._id}
        expect(response).to redirect_to users_path
      end
    end
    describe "GET edit" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :edit, params: { :_id => @user._id,  :id => @user._id}
        expect(response).to redirect_to login_path
      end
      it "returns the edit user if the user has access to it" do
        session[:type] = "ADMIN"
        get :edit, params: { :_id => @user._id,  :id => @user._id}
        expect(response).to render_template("edit")
      end
    end
    describe "POST create" do
      it "returns the login is there is no session" do
        session[:type] = "NONE"
        post :create, params: { :user => { :username => "username2", :name => "name2", :email => "email2@email.com", :password => "Password2" } }
        expect(response).to redirect_to login_path
      end
      it "returns the users page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :create, params: { :user => { :username => "username2", :name => "name2", :email => "email2@email.com", :password => "Password2" } }
        expect(response).to redirect_to users_path
      end
      it "returns the notes of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        post :create, params: {:user => { :username => "username3", :name => "name3", :email => "email3@email.com", :password => "Password3" } }
        expect(response).to redirect_to notesUser_path(:user => "User")
      end
    end
    describe "PATCH update" do
      let(:id1) { "username2" }
      let(:id2) { "username3" }
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        patch :update, params: { :user => { :username => "username3", :name => "name3", :email => "email3@email.com", :password => "Password3" }, :id => id1, :_id => "username2", :name => "name2", :email => "email2@email.com", :password => "Password2" }
        expect(response).to redirect_to login_path
      end
      it "returns the users page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        patch :update, params: { :user => { :username => "username3", :name => "name3", :email => "email3@email.com", :password => "Password3" }, :id => id1, :_id => "username2", :name => "name2", :email => "email2@email.com", :password => "Password2" }
        expect(response).to redirect_to users_path
      end
      it "returns the notes of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        patch :update, params: { :user => { :username => "username3", :name => "name3", :email => "email3@email.com", :password => "Password3" }, :id => id1, :_id => "username2", :name => "name2", :email => "email2@email.com", :password => "Password2" }
        expect(response).to redirect_to notesUser_path(:user => "User")
      end
    end
    describe "DELETE destroy" do
      let(:id1) { "username2" }
      let(:id2) { "username3" }
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        delete :destroy, params: { :id => id1, :_id => id1}
        expect(response).to redirect_to login_path
      end
      it "returns the users page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        delete :destroy, params: { :id => id1, :_id => id1 }
        expect(response).to redirect_to users_path
      end
      it "returns the notes of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        delete :destroy, params: { :id => id2, :_id => id2 }
        expect(response).to redirect_to notesUser_path(:user => "User")
      end
    end
  end
end
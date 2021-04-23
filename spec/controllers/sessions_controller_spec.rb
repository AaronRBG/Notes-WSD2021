require "rails_helper"

RSpec.describe SessionsController, :type => :controller do
  describe "GET login" do
    it "returns the login page" do
      expect(:get => "/login").to route_to("sessions#new")
      get :new
      expect(response).to render_template(:new)
    end
  end
  describe "POST login" do
    it "returns the login page if username is not found" do
      expect(:post => "/login").to route_to("sessions#create")
      post :create, params: { :username => "", :password => "" }
      expect(response).to redirect_to login_path
    end
    it "returns the login page if password is incorrect" do
      post :create, params: { :username => "Admin", :password => "" }
      expect(response).to redirect_to login_path
    end
    it "returns the notes page if credentials are correct and belong to an admin" do
      post :create, params: { :username => "Admin", :password => "Admin1234" }
      expect(response).to redirect_to notes_path
    end
    it "returns the notes of the user if credentials are correct and belong to a user" do
      post :create, params: { :username => "User", :password => "User1234" }
      expect(response).to redirect_to notesUser_path(:user => "User")
    end
  end
  describe "DELETE logout" do
    it "removes the session if any and returns the login page" do
      expect(:delete => "/logout").to route_to("sessions#logout")
      session[:_id] = Session.find_by(:user_id => "User")._id
      delete :logout
      expect(response).to redirect_to login_path
      session[:_id] = Session.find_by(:user_id => "Admin")._id
      delete :logout
      expect(response).to redirect_to login_path
    end
  end
end
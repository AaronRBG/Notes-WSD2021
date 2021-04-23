require "rails_helper"

RSpec.describe NotesController, :type => :controller do
  context "NotesController" do
    subject { @note }
    before(:all) do
      @note = Note.create!(title: "titulo", text: "Texto")
      @note.save!
    end
    after(:all) do
      @note.delete
    end
    describe "GET notes" do
      it "returns the login if there is no session" do
        expect(:get => "/notes").to route_to("notes#index")
        session[:type] = "NONE"
        get :index
        expect(response).to redirect_to login_path
      end
      it "returns the notes page if the session is of type admin" do
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
        get :show, params: { :_id => @note._id,  :id => @note._id}
        expect(response).to redirect_to login_path
      end
      it "returns the show note page if the user has access to it" do
        session[:type] = "ADMIN"
        get :show, params: { :_id => @note._id,  :id => @note._id}
        expect(response).to render_template("show")
      end
    end
    describe "GET new" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :new
        expect(response).to redirect_to login_path
      end
      it "returns the create new note if there is a session" do
        session[:user_id] = "Admin"
        get :new
        expect(response).to render_template("new")
      end
    end
    describe "GET share" do
      it "returns the login if there is no session" do
        expect(:get => "/share").to route_to("notes#getShare")
        session[:type] = "NONE"
        get :getShare, params: { :_id => @note._id}
        expect(response).to redirect_to login_path
      end
      it "returns the share note page if there is the user has access to this operation" do
        session[:type] = "ADMIN"
        get :getShare, params: { :_id => @note._id}
        expect(response).to render_template("share")
      end
    end
    describe "POST share" do
      it "returns the login if there is no session" do
        expect(:post => "/share").to route_to("notes#share")
        session[:user_id] = "NONE"
        post :share, params: { :_id => @note._id,  :id => @note._id}
        expect(response).to redirect_to login_path
      end
      it "Shares the note with the user, if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :share, params: { :note => @note._id,  :user => "Admin"}
        expect(response).to redirect_to notesUser_path(:user => "Admin")
        UserNote.find_by(:note_id => @note._id, :user_id => "Admin").delete
      end
    end
    describe "GET notesUser" do
      it "returns the login if there is no session" do
        expect(:get => "/notesUser").to route_to("notes#notesUser")
        session[:user_id] = "NONE"
        get :notesUser, params: { :user => "Admin"}
        expect(response).to redirect_to login_path
      end
      it "returns the current user notes if the session is active" do
        session[:user_id] = "Admin"
        get :notesUser, params: { :user => "Admin"}
        expect(response).to render_template("index")
      end
    end
    describe "GET edit" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :edit, params: { :_id => @note._id,  :id => @note._id}
        expect(response).to redirect_to login_path
      end
      it "returns the edit new note if the user has access to it" do
        session[:type] = "ADMIN"
        get :edit, params: { :_id => @note._id,  :id => @note._id}
        expect(response).to render_template("edit")
      end
    end
    describe "POST create" do
      it "returns the login is there is no session" do
        session[:type] = "NONE"
        post :create, params: { :note => { :title => "Titulo2", :text => "Texto2"} }
        expect(response).to redirect_to login_path
      end
      it "returns the notes page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :create, params: { :note => { :title => "Titulo2", :text => "Texto2"} }
        expect(response).to redirect_to notes_path
      end
      it "returns the notes of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        post :create, params: { :note => { :title => "Titulo3", :text => "Texto3"} }
        expect(response).to redirect_to notesUser_path(:user => "User")
      end
    end
    describe "PATCH update" do
      let(:id1) { Note.find_by(:title => "Titulo2")._id }
      let(:id2) { Note.find_by(:title => "Titulo3")._id }
      it "returns the login is there is no session" do
        session[:user_id] = "NONE"
        patch :update, params: { :id => id1, :_id => id1, :note => { :title => "Titulo2", :text => "Texto2"} }
        expect(response).to redirect_to login_path
      end
      it "returns the notes page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        patch :update, params: { :id => id1, :_id => id1, :note => { :title => "Titulo2", :text => "Texto2"} }
        expect(response).to redirect_to notes_path
      end
      it "returns the notes of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        patch :update, params: { :id => id2, :_id => id2, :note => { :title => "Titulo3", :text => "Texto3"} }
        expect(response).to redirect_to notesUser_path(:user => "User")
      end
    end
    describe "DELETE destroy" do
      let(:id1) { Note.find_by(:title => "Titulo2")._id }
      let(:id2) { Note.find_by(:title => "Titulo3")._id }
      it "returns the login is there is no session" do
        session[:user_id] = "NONE"
        delete :destroy, params: { :id => id1, :_id => id1}
        expect(response).to redirect_to login_path
      end
      it "returns the notes page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        delete :destroy, params: { :id => id1, :_id => id1 }
        expect(response).to redirect_to notes_path
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
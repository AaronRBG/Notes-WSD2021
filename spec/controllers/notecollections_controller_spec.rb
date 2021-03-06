require "rails_helper"

RSpec.describe NotecollectionsController, :type => :controller do
  context "NotecollectionsController" do
    subject { @notecollection }
    before(:all) do
      @notecollection = Notecollection.create!(:name => "Titulo")
      @notecollection.save!
    end
    after(:all) do
      @notecollection.delete
    end
    describe "GET notecollections" do
      it "returns the login if there is no session" do
        expect(:get => "/notecollections").to route_to("notecollections#index")
        session[:type] = "NONE"
        get :index
        expect(response).to redirect_to login_path
      end
      it "returns the notecollections page if the session is of type admin" do
        session[:type] = "ADMIN"
        get :index
        expect(response).to render_template("index")
      end
      it "returns the notecollections of the user if the session is of type user" do
        session[:type] = "USER"
        get :index
        expect(response).to redirect_to notecollectionsUser_path
      end
    end
    describe "GET show" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :show, params: { :_id => @notecollection._id,  :id => @notecollection._id}
        expect(response).to redirect_to login_path
      end
      it "returns the show collection page if the user has access to it" do
        session[:type] = "ADMIN"
        get :show, params: { :_id => @notecollection._id,  :id => @notecollection._id}
        expect(response).to render_template("show")
      end
    end
    describe "GET new" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :new
        expect(response).to redirect_to login_path
      end
      it "returns the create new notecollection if there is a session" do
        session[:user_id] = "Admin"
        get :new
        expect(response).to render_template("new")
      end
    end
    describe "GET shareCollection" do
      it "returns the login if there is no session" do
        expect(:get => "/shareCollection").to route_to("notecollections#getShare")
        session[:type] = "NONE"
        get :getShare, params: { :_id => @notecollection._id}
        expect(response).to redirect_to login_path
      end
      it "returns the share collection page if there is the user has access to this operation" do
        session[:type] = "ADMIN"
        get :getShare, params: { :_id => @notecollection._id}
        expect(response).to render_template("share")
      end
    end
    describe "POST shareCollection" do
      it "returns the login if there is no session" do
        expect(:post => "/shareCollection").to route_to("notecollections#share")
        session[:user_id] = "NONE"
        post :share, params: { :_id => @notecollection._id,  :id => @notecollection._id}
        expect(response).to redirect_to login_path
      end
      it "Shares the collection with the user, if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :share, params: { :_id => @notecollection._id,  :user => "Admin"}
        expect(response).to redirect_to notecollections_path
      end
    end
    describe "GET collectionsUser" do
      it "returns the login if there is no session" do
        expect(:get => "/notecollectionsUser").to route_to("notecollections#notecollectionsUser")
        session[:user_id] = "NONE"
        get :notecollectionsUser, params: { :user => "Admin"}
        expect(response).to redirect_to login_path
      end
      it "returns the current user collections if the session is active" do
        session[:user_id] = "Admin"
        get :notecollectionsUser, params: { :user => "Admin"}
        expect(response).to render_template("index")
      end
    end
    describe "GET edit" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :edit, params: { :_id => @notecollection._id,  :id => @notecollection._id}
        expect(response).to redirect_to login_path
      end
      it "returns the edit collection if the user has access to it" do
        session[:type] = "ADMIN"
        get :edit, params: { :_id => @notecollection._id,  :id => @notecollection._id}
        expect(response).to render_template("edit")
      end
    end
    describe "GET add" do
      it "returns the login if there is no session" do
        expect(:get => "/add").to route_to("notecollections#getAdd")
        session[:type] = "NONE"
        get :getAdd, params: { :_id => @notecollection._id}
        expect(response).to redirect_to login_path
      end
      it "returns the add note to collection page if there is the user has access to this operation" do
        session[:type] = "ADMIN"
        get :getAdd, params: { :_id => @notecollection._id}
        expect(response).to render_template("add")
      end
    end
    describe "POST add" do
      it "returns the login if there is no session" do
        expect(:post => "/add").to route_to("notecollections#add")
        session[:user_id] = "NONE"
        note = Note.create(title: "titulo", text: "Texto")
        note.save
        post :add, params: { :_id => @notecollection._id, :id => @notecollection._id, :note => note._id }
        expect(response).to redirect_to login_path
      end
      it "Adds the note to the collection, if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        note = Note.create!(title: "titulo2", text: "Texto2")
        note.save!
        post :add, params: { :_id => @notecollection._id, :id => @notecollection._id, :note => note._id }
        expect(response).to redirect_to notecollections_path
      end
    end
    let(:id) { Note.find_by(:title => "titulo") }
    describe "POST removeNote" do
      it "returns the login if there is no session" do
        expect(:post => "/removeNote").to route_to("notecollections#removeNote")
        session[:user_id] = "NONE"
        note = Note.find_by(:title => "titulo")
        post :removeNote, params: { :_id => @notecollection._id, :id => @notecollection._id, :note_id => note._id }
        note.delete
        expect(response).to redirect_to login_path
      end
      it "Removes the note from the collection, if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        note = Note.find_by(:title => "titulo2")
        post :removeNote, params: { :_id => @notecollection._id, :id => @notecollection._id, :note_id => note._id }
        note.delete
        expect(response).to redirect_to notecollections_path
      end
    end
    describe "POST create" do
      it "returns the login is there is no session" do
        session[:type] = "NONE"
        post :create, params: { :notecollection => { :name => "Titulo2" } }
        expect(response).to redirect_to login_path
      end
      it "returns the collections page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :create, params: { :notecollection => { :name => "Titulo2" } }
        expect(response).to redirect_to notecollections_path
      end
      it "returns the collections of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        post :create, params: { :notecollection => { :name => "Titulo3" } }
        expect(response).to redirect_to notecollectionsUser_path(:user => "User")
      end
    end
    describe "PATCH update" do
      let(:id1) { Notecollection.find_by(:name => "Titulo2")._id }
      let(:id2) { Notecollection.find_by(:name => "Titulo3")._id }
      it "returns the login is there is no session" do
        session[:user_id] = "NONE"
        patch :update, params: { :id => id1, :_id => id1, :notecollection => { :name => "Titulo2"} }
        expect(response).to redirect_to login_path
      end
      it "returns the notes page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        patch :update, params: { :id => id1, :_id => id1, :notecollection => { :name => "Titulo2"} }
        expect(response).to redirect_to notecollections_path
      end
      it "returns the notes of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        patch :update, params: { :id => id2, :_id => id2, :notecollection => { :name => "Titulo3"} }
        expect(response).to redirect_to notecollectionsUser_path(:user => "User")
      end
    end
    describe "DELETE destroy" do
      let(:id1) { Notecollection.find_by(:name => "Titulo2")._id }
      let(:id2) { Notecollection.find_by(:name => "Titulo3")._id }
      it "returns the login is there is no session" do
        session[:user_id] = "NONE"
        delete :destroy, params: { :id => id1, :_id => id1}
        expect(response).to redirect_to login_path
      end
      it "returns the notes page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        delete :destroy, params: { :id => id1, :_id => id1 }
        expect(response).to redirect_to notecollections_path
      end
      it "returns the notes of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        delete :destroy, params: { :id => id2, :_id => id2 }
        expect(response).to redirect_to notecollectionsUser_path(:user => "User")
      end
    end
  end
end
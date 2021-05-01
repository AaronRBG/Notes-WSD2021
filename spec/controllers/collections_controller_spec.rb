require "rails_helper"

RSpec.describe CollectionsController, :type => :controller do
  context "CollectionsController" do
    subject { @collection }
    before(:all) do
      @collection = Collection.create!(:name => "Titulo")
      @collection.save!
    end
    after(:all) do
      @collection.delete
    end
    describe "GET collections" do
      it "returns the login if there is no session" do
        expect(:get => "/collections").to route_to("collections#index")
        session[:type] = "NONE"
        get :index
        expect(response).to redirect_to login_path
      end
      it "returns the collections page if the session is of type admin" do
        session[:type] = "ADMIN"
        get :index
        expect(response).to render_template("index")
      end
      it "returns the collections of the user if the session is of type user" do
        session[:type] = "USER"
        get :index
        expect(response).to redirect_to collectionsUser_path
      end
    end
    describe "GET show" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :show, params: { :_id => @collection._id,  :id => @collection._id}
        expect(response).to redirect_to login_path
      end
      it "returns the show collection page if the user has access to it" do
        session[:type] = "ADMIN"
        get :show, params: { :_id => @collection._id,  :id => @collection._id}
        expect(response).to render_template("show")
      end
    end
    describe "GET new" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :new
        expect(response).to redirect_to login_path
      end
      it "returns the create new collection if there is a session" do
        session[:user_id] = "Admin"
        get :new
        expect(response).to render_template("new")
      end
    end
    describe "GET shareCollection" do
      it "returns the login if there is no session" do
        expect(:get => "/shareCollection").to route_to("collections#getShare")
        session[:type] = "NONE"
        get :getShare, params: { :_id => @collection._id}
        expect(response).to redirect_to login_path
      end
      it "returns the share collection page if there is the user has access to this operation" do
        session[:type] = "ADMIN"
        get :getShare, params: { :_id => @collection._id}
        expect(response).to render_template("share")
      end
    end
    describe "POST shareCollection" do
      it "returns the login if there is no session" do
        expect(:post => "/shareCollection").to route_to("collections#share")
        session[:user_id] = "NONE"
        post :share, params: { :_id => @collection._id,  :id => @collection._id}
        expect(response).to redirect_to login_path
      end
      it "Shares the collection with the user, if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :share, params: { :collection => @collection._id,  :user => "Admin"}
        expect(response).to redirect_to collectionsUser_path(:user => "Admin")
        UserCollection.find_by(:collection_id => @collection._id, :user_id => "Admin").delete
      end
    end
    describe "GET collectionsUser" do
      it "returns the login if there is no session" do
        expect(:get => "/collectionsUser").to route_to("collections#collectionsUser")
        session[:user_id] = "NONE"
        get :collectionsUser, params: { :user => "Admin"}
        expect(response).to redirect_to login_path
      end
      it "returns the current user collections if the session is active" do
        session[:user_id] = "Admin"
        get :collectionsUser, params: { :user => "Admin"}
        expect(response).to render_template("index")
      end
    end
    describe "GET edit" do
      it "returns the login if there is no session" do
        session[:user_id] = "NONE"
        get :edit, params: { :_id => @collection._id,  :id => @collection._id}
        expect(response).to redirect_to login_path
      end
      it "returns the edit collection if the user has access to it" do
        session[:type] = "ADMIN"
        get :edit, params: { :_id => @collection._id,  :id => @collection._id}
        expect(response).to render_template("edit")
      end
    end
    describe "GET add" do
      it "returns the login if there is no session" do
        expect(:get => "/add").to route_to("collections#getAdd")
        session[:type] = "NONE"
        get :getAdd, params: { :_id => @collection._id}
        expect(response).to redirect_to login_path
      end
      it "returns the add note to collection page if there is the user has access to this operation" do
        session[:type] = "ADMIN"
        get :getAdd, params: { :_id => @collection._id}
        expect(response).to render_template("add")
      end
    end
    describe "POST add" do
      it "returns the login if there is no session" do
        expect(:post => "/add").to route_to("collections#add")
        session[:user_id] = "NONE"
        note = Note.create(title: "titulo", text: "Texto")
        note.save
        post :add, params: { :_id => @collection._id, :id => @collection._id, :note => note._id }
        expect(response).to redirect_to login_path
      end
      it "Adds the note to the collection, if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        note = Note.create!(title: "titulo", text: "Texto")
        note.save!
        post :add, params: { :_id => @collection._id, :id => @collection._id, :note => note._id }
        expect(response).to redirect_to collectionsUser_path(:user => "Admin")
      end
    end
    let(:id) { Note.find_by(:title => "titulo") }
    describe "POST removeNote" do
      it "returns the login if there is no session" do
        expect(:post => "/removeNote").to route_to("collections#removeNote")
        session[:user_id] = "NONE"
        post :removeNote, params: { :_id => @collection._id, :id => @collection._id, :note => note._id }
        expect(response).to redirect_to login_path
      end
      it "Removes the note from the collection, if the user has access to this operation" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :removeNote, params: { :_id => @collection._id, :id => @collection._id, :note => note._id }
        expect(response).to redirect_to collectionsUser_path(:user => "Admin")
      end
    end
    describe "POST create" do
      it "returns the login is there is no session" do
        session[:type] = "NONE"
        post :create, params: { :collection => { :name => "Titulo2" } }
        expect(response).to redirect_to login_path
      end
      it "returns the collections page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        post :create, params: { :collection => { :name => "Titulo2" } }
        expect(response).to redirect_to notes_path
      end
      it "returns the collections of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        post :create, params: { :collection => { :name => "Titulo3" } }
        expect(response).to redirect_to collectionsUser_path(:user => "User")
      end
    end
    describe "PATCH update" do
      let(:id1) { Collection.find_by(:name => "Titulo2")._id }
      let(:id2) { Collection.find_by(:name => "Titulo3")._id }
      it "returns the login is there is no session" do
        session[:user_id] = "NONE"
        patch :update, params: { :id => id1, :_id => id1, :collection => { :name => "Titulo2"} }
        expect(response).to redirect_to login_path
      end
      it "returns the notes page if credentials are correct and belong to an admin" do
        session[:type] = "ADMIN"
        session[:user_id] = "Admin"
        patch :update, params: { :id => id1, :_id => id1, :collection => { :name => "Titulo2"} }
        expect(response).to redirect_to notes_path
      end
      it "returns the notes of the user if credentials are correct and belong to a user" do
        session[:type] = "USER"
        session[:user_id] = "User"
        patch :update, params: { :id => id2, :_id => id2, :collection => { :name => "Titulo3"} }
        expect(response).to redirect_to notesUser_path(:user => "User")
      end
    end
    describe "DELETE destroy" do
      let(:id1) { Collection.find_by(:name => "Titulo2")._id }
      let(:id2) { Collection.find_by(:name => "Titulo3")._id }
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
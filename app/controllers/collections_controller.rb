class CollectionsController < ApplicationController
    def index
        if session[:type] == "ADMIN"
            @collections= Collection.all
        elsif session[:type] == "USER"
            redirect_to collectionsUser_path(:user => session[:user_id])
        else
            redirect_to login_path
        end
    end

    def new
        if session[:user_id] != "NONE"
          @collection = Collection.new
        else
          redirect_to login_path
        end
    end

    def show
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:_id], :user_id => session[:user_id])
            @collection = Collection.find(params[:_id])
          else
            redirect_to collectionsUser_path(:user => session[:user_id])
          end
        else
          redirect_to login_path
        end
    end

    def getShare
      if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:_id], :user_id => session[:user_id])
        @collection = Collection.find(params[:_id])
        @users = User.all
        render :share
      elsif session[:type] == "USER"
        redirect_to collectionsUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end

    def share
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:collection], :user_id => session[:user_id])
          userCollection = UserCollection.new(:collection_id => params[:collection], :user_id => params[:user])
          userCollection.save
        end
        redirect_to collectionsUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end

    def getAdd
      if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:_id], :user_id => session[:user_id])
        @collection = Collection.find(params[:_id])
        if session[:type] == "ADMIN"
          @notes = Note.all
        else
          usernotes = UserNote.where(:user_id => params[:user]).to_a
          notes = []
          if !usernotes.nil?
            if usernotes.kind_of?(Array)
              usernotes.each do |item|
                note = Note.find(item.note_id)
                notes.append(note)
              end
            else
              note = Note.find(usernotes.note_id)
              notes.append(note)
            end
          end
          @notes = notes
        end
        render :add
      elsif session[:type] == "USER"
        redirect_to collectionsUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end

    def add
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:collection], :user_id => session[:user_id])
          @collection = Collection.find(params[:_id])
          notes = @collection.notes
          notes.append(params[:note_id])
          @collection.update(:notes => notes)
        end
        redirect_to collectionsUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end

    def removeNote
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:collection], :user_id => session[:user_id])
          @collection = Collection.find(params[:_id])
          notes = @collection.notes
          if notes.include?(params[:note_id])
            notes = notes.delete(params[:note_id])
            @collection.update(:notes => notes)
          end
        end
        redirect_to collectionsUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end
    
    def edit
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:_id], :user_id => session[:user_id])
            @collection = Collection.find(params[:_id])
          else
            redirect_to collectionsUser_path(:user => session[:user_id])
          end
        else
          redirect_to login_path
        end
      end

    
    def create
        if session[:type] == "ADMIN" || session[:type] == "USER"
          @collection = Collection.new(collection_params)
          if @collection.save
            userCollection = UserCollection.new(:collection => @collection._id, :user => session[:user_id])
            userCollection.save!
          end
          if session[:type] == "ADMIN"
            redirect_to collections_path
          else
            redirect_to collectionsUser_path(:user => session[:user_id])
          end
        else
          redirect_to login_path
        end
      end

    def update
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id=> params[:_id], :user_id => session[:user_id])
            aux = Collection.new(collection_params)
            @collection = Collection.find(params[:_id])
            @collection.update(:name => aux.title)
            if session[:type] == "ADMIN"
              redirect_to collections_path
            else
              redirect_to collectionsUser_path(:user => session[:user_id])
            end
          end
        else
          redirect_to login_path
        end
    end

    def destroy
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:_id], :user_id => session[:user_id])
            @collection = Collection.find(params[:_id])
            collectionID = @collection._id
            userCollection = UserCollection.find_by(:collection_id => params[:_id], :user_id => session[:user_id])
            if UserCollection.where(:collection_id => collectionID).count == 1
              @collection.destroy
              userCollection = UserCollection.find_by(:collection_id => params[:_id])
            end
            if userCollection != "undefined"
                userCollection.delete
            end
            if session[:type] = collections_path
            else
              redirect_to collectionsUser_path(:user => session[:user_id])
            end
          end
        else
          redirect_to login_path
        end
    end

    def collectionsUser
        if params[:user] == session[:user_id]
          userCollections = UserCollection.where(:user_id => params[:user]).to_a
          collections = []
          if !userCollections.nil?
            if userCollections.kind_of?(Array)
                userCollections.each do |item|
                collection = Collection.find(item.collection_id)
                collections.append(collection)
              end
            else
              collection = Collection.find(userCollections.note_id)
              collections.append(collection)
            end
          end
          @collections = collections
          render :index
        elsif session[:user_id] != "NONE"
          redirect_to collectionsUser_path(:user => session[:user_id])
        else
          redirect_to login_path
        end
      end

    private
    # Only allow a list of trusted parameters through.
    def collection_params
      params.require(:collection).permit(:_id, :name)
    end
end
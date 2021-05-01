class CollecionsController < ApplicationController
    def index
        if session[:type] == "ADMIN"
            @collections= Collecion.all
        elsif session[:type] == "USER"
            redirect_to collectionsUser_path(:user => session[:user_id])
        else
            redirect_to login_path
        end
    end

    def new
        if session[:user_id] != "NONE"
          @collecion = Collection.new
        else
          redirect_to login_path
        end
    end

    def show
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:collection_id => params[:_id], :user_id => session[:user_id])
            @note = Note.find(params[:_id])
          else
            redirect_to collectionsUser_path(:user => session[:user_id])
          end
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
          @collection = Collecion.new(collection_params)
          if @collection.save
            userCollection = UserCollection.new(:collection => @collection._id, :user => session[:user_id])
            userCollection.save!
          end
          if session[:type] == "ADMIN"
            redirect_to notes_path
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
            aux = Collecion.new(collection_params)
            @collection = Collecion.find(params[:_id])
            @collection.update(:title => aux.title)
            if session[:type] == "ADMIN"
              redirect_to notes_path
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
            @collection = Collecion.find(params[:_id])
            collectionID = @collection._id
            userCollection = UserCollection.find_by(:collection_id => params[:_id], :user_id => session[:user_id])
            if UserCollection.where(:collection_id => collectionID).count == 1
              @collection.destroy
              userCollection = UserCollection.find_by(:collection_id => params[:_id])
            end
            if userCollection != "undefined"
                userCollection.delete
            end
            if session[:type] == "ADMIN"
              redirect_to notes_path
            else
              redirect_to collectionsUser_path(:user => session[:user_id])
            end
          end
        else
          redirect_to login_path
        end
    end

##revisar collectionsUsers

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
              collection = Collecion.find(userCollections.note_id)
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
      params.require(:collection).permit(:_id, :title)
    end
end

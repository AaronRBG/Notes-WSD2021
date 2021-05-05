class NotecollectionsController < ApplicationController
    def index
        if session[:type] == "ADMIN"
            @notecollections= Notecollection.all
        elsif session[:type] == "USER"
            redirect_to notecollectionsUser_path(:user => session[:user_id])
        else
            redirect_to login_path
        end
    end



    def new
        if session[:user_id] != "NONE"
          @notecollection = Notecollection.new
        else
          redirect_to login_path
        end
    end



    def show
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
            @notecollection = Notecollection.find(params[:_id])
          else
            redirect_to notecollectionsUser_path(:user => session[:user_id])
          end
        else
          redirect_to login_path
        end
    end



    def getShare
      if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
        @notecollection = Notecollection.find(params[:_id])
        users = User.all
        @users = []
        users.each do |item|
          if !(UserNote.find_by(:note_id => params[:_id], :user_id => item._id))
            @users.append(item)
          end
        end
        render :share
      elsif session[:type] == "USER"
        redirect_to notecollectionsUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end



    def share
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
          userCollection = UserCollection.new(:notecollection_id => params[:_id], :user_id => params[:user])
          userCollection.save!
        end
        if session[:type] == "ADMIN"
          redirect_to notecollections_path
        else
          redirect_to notecollectionsUser_path(:user => session[:user_id])
        end
      else
        redirect_to login_path
      end
    end

    def getAdd
      if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
        @notecollection = Notecollection.find(params[:_id])
        if session[:type] == "ADMIN"
          @notes = Note.all
        else
          usernotes = UserNote.where(:user_id => session[:user_id]).to_a
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
        redirect_to notecollectionsUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end



    def add
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
          @notecollection = Notecollection.find(params[:_id])
          @notecollection.notes.append(params[:note_id])
          @notecollection.save!
        end
        if session[:type] == "ADMIN"
          redirect_to notecollections_path
        else
          redirect_to notecollectionsUser_path(:user => session[:user_id])
        end
      else
        redirect_to login_path
      end
    end



    def removeNote
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
          @notecollection = Notecollection.find(params[:_id])
          if @notecollection.notes.include?(params[:note_id])
            @notecollection.notes.delete(params[:note_id])
            @notecollection.save!
          end
        end
        if session[:type] == "ADMIN"
          redirect_to notecollections_path
        else
          redirect_to notecollectionsUser_path(:user => session[:user_id])
        end
      else
        redirect_to login_path
      end
    end


    
    def edit
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
            @notecollection = Notecollection.find(params[:_id])
          else
            redirect_to notecollectionsUser_path(:user => session[:user_id])
          end
        else
          redirect_to login_path
        end
      end

    
    def create
        if session[:type] == "ADMIN" || session[:type] == "USER"
          @notecollection = Notecollection.new(notecollection_params)
          if @notecollection.save
            userCollection = UserCollection.new(:notecollection => @notecollection._id, :user => session[:user_id])
            userCollection.save!
          end
          if session[:type] == "ADMIN"
            redirect_to notecollections_path
          else
            redirect_to notecollectionsUser_path(:user => session[:user_id])
          end
        else
          redirect_to login_path
        end
      end




    def update
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id=> params[:_id], :user_id => session[:user_id])
            aux = Notecollection.new(notecollection_params)
            @notecollection = Notecollection.find(params[:_id])
            @notecollection.update(:name => aux.name)
            if session[:type] == "ADMIN"
              redirect_to notecollections_path
            else
              redirect_to notecollectionsUser_path(:user => session[:user_id])
            end
          end
        else
          redirect_to login_path
        end
    end

    

    def destroy
        if session[:user_id] != "NONE"
          if session[:type] == "ADMIN" || UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
            @notecollection = Notecollection.find(params[:_id])
            notecollectionID = @notecollection._id
            userCollection = UserCollection.find_by(:notecollection_id => params[:_id], :user_id => session[:user_id])
            if UserCollection.where(:notecollection_id => notecollectionID).count == 1
              @notecollection.destroy
              userCollection = UserCollection.find_by(:notecollection_id => params[:_id])
            end
            if userCollection != "undefined" && userCollection != nil
                userCollection.delete
            end
            if session[:type] == "ADMIN"
              redirect_to notecollections_path
            else
              redirect_to notecollectionsUser_path(:user => session[:user_id])
            end
          end
        else
          redirect_to login_path
        end
    end

    def notecollectionsUser
        if params[:user] == session[:user_id]
          userCollections = UserCollection.where(:user_id => params[:user]).to_a
          notecollections = []
          if !userCollections.nil?
            if userCollections.kind_of?(Array)
                userCollections.each do |item|
                notecollection = Notecollection.find(item.notecollection_id)
                notecollections.append(notecollection)
              end
            else
              notecollection = Notecollection.find(userCollections.note_id)
              notecollections.append(notecollection)
            end
          end
          @notecollections = notecollections
          render :index
        elsif session[:user_id] != "NONE"
          redirect_to notecollectionsUser_path(:user => session[:user_id])
        else
          redirect_to login_path
        end
      end

    private
    # Only allow a list of trusted parameters through.
    def notecollection_params
      params.require(:notecollection).permit(:_id, :name)
    end
end
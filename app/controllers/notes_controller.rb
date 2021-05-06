class NotesController < ApplicationController
  
    def index
      if session[:type] == "ADMIN"
        @notes = Note.all
      elsif session[:type] == "USER"
        redirect_to notesUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end
    
    def show
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserNote.find_by(:note_id => params[:_id], :user_id => session[:user_id])
          @note = Note.find(params[:_id])
        else
          redirect_to notesUser_path(:user => session[:user_id])
        end
      else
        redirect_to login_path
      end
    end
  
    def new
      if session[:user_id] != "NONE"
        @note = Note.new
      else
        redirect_to login_path
      end
    end

    def getShare
      if session[:type] == "ADMIN" || UserNote.find_by(:note_id => params[:_id], :user_id => session[:user_id])
        @note = Note.find(params[:_id])
        users = User.all
        @users = []
        users.each do |item|
          if !(UserNote.find_by(:note_id => params[:_id], :user_id => item._id))
            @users.append(item)
          end
        end
        render :share
      elsif session[:type] == "USER"
        redirect_to notesUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end

    def notesUser
      if params[:user] == session[:user_id]
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
        render :index
      elsif session[:user_id] != "NONE"
        redirect_to notesUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end

    def edit
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserNote.find_by(:note_id => params[:_id], :user_id => session[:user_id])
          @note = Note.find(params[:_id])
        else
          redirect_to notesUser_path(:user => session[:user_id])
        end
      else
        redirect_to login_path
      end
    end

    def share
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserNote.find_by(:note_id => params[:note], :user_id => session[:user_id])
          usernote = UserNote.new(:note_id => params[:note], :user_id => params[:user])
          usernote.save
        end
        redirect_to notesUser_path(:user => session[:user_id])
      else
        redirect_to login_path
      end
    end
  
    def create
      if session[:type] == "ADMIN" || session[:type] == "USER"
        @note = Note.new(note_params)
        if @note.save
          usernote = UserNote.new(:note => @note._id, :user => session[:user_id])
          usernote.save!
        end
        if session[:type] == "ADMIN"
          redirect_to notes_path
        else
          redirect_to notesUser_path(:user => session[:user_id])
        end
      else
        redirect_to login_path
      end
    end
  
    def update
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserNote.find_by(:note_id => note_params[:_id], :user_id => session[:user_id])
          aux = Note.new(note_params)
          @note = Note.find(note_params[:_id])
          @note.update(:title => aux.title, :text => aux.text, :image => aux.image)
        end
        if session[:type] == "ADMIN"
          redirect_to notes_path
        else
          redirect_to notesUser_path(:user => session[:user_id])
        end
      else
        redirect_to login_path
      end
    end
  
    def destroy
      if session[:user_id] != "NONE"
        if session[:type] == "ADMIN" || UserNote.find_by(:note_id => params[:_id], :user_id => session[:user_id])
          @note = Note.find(params[:_id])
          noteID = @note._id
          usernote = UserNote.find_by(:note_id => params[:_id], :user_id => session[:user_id])
          if UserNote.where(:note_id => noteID).count == 1
            @note.delete
            usernote = UserNote.find_by(:note_id => params[:_id])
            notecollections = Notecollection.where(:notes => params[:_id]).to_a
            i = 0
            while i < notecollections.length do
              notecollections[i].notes.delete(params[:_id])
              notecollections[i].save!
              i = i+1
            end
          end
          if usernote != "undefined"
            usernote.delete
          end
          if session[:type] == "ADMIN"
            redirect_to notes_path
          else
            redirect_to notesUser_path(:user => session[:user_id])
          end
        end
      else
        redirect_to login_path
      end
    end

    private
      # Only allow a list of trusted parameters through.
      def note_params
        params.require(:note).permit(:_id, :title, :text, :image)
      end
end
  
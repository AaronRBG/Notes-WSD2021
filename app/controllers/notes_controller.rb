class NotesController < ApplicationController
  
    def index
      @notes = Note.all
    end

    def show
      @note = Note.find(params[:_id])
    end
  
    def new
      @note = Note.new
    end

    def getShare
      @note = Note.find(params[:_id])
      @users = User.all
      render :share
    end

    def notesUser
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
    end

    def edit
      @note = Note.find(params[:_id])
    end

    def share
      usernote = UserNote.new(:note => params[:note], :user => params[:user])
      usernote.save
      redirect_to notesUser_path(params[:user])
    end
  
    def create
      @note = Note.new(note_params)
      if @note.save
        usernote = UserNote.new(:note => @note._id, :user => session[:user_id])
        usernote.save!
      end
      redirect_to notes_path
    end
  
    def update
      aux = Note.new(note_params)
      @note = Note.find(aux._id)
      @note.update(:title => aux.title, :text => aux.text, :image => aux.image)
      redirect_to notes_path
    end
  
    def destroy
      @note = Note.find(params[:_id])
      noteID = @note._id
      if @note.destroy
        usernote = UserNote.find_by(:note_id => noteID)
        usernote.delete
      end
      render :index
    end

    private
      # Only allow a list of trusted parameters through.
      def note_params
        params.require(:note).permit(:_id, :title, :text, :image)
      end
end
  
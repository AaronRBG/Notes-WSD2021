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
      @user = params[:userShared]
    end

    def edit
      @note = Note.find(params[:_id])
    end

    def share
      UserNote.new(@note._id, @user)
    end
  
    def create
      @note = Note.new(note_params)
  
      respond_to do |format|
        if @note.save
          UserNote.new(@note._id, params[:user])
          format.html { redirect_to action: "index", notice: "Note was successfully created." }
        else
          format.html { redirect_to action: "index", notice: "Note was not created." }
        end
      end
    end
  
    def update
      aux = Note.new(note_params)
      @note = Note.find(aux._id)
      respond_to do |format|
        if @note.update(:title => aux.title, :text => aux.text, :image => aux.image)
            format.html { redirect_to action: "index", notice: "Note was successfully created." }
        else
          format.html { redirect_to action: "index", notice: "Note was not created." }
        end
      end
    end
  
    def destroy
        @note = Note.find(params[:_id])
        noteID = @note._id
        if @note.destroy
          UserNote.find(:note_id => noteID).destroy
        respond_to do |format|
            format.html { redirect_to action: "index", notice: "Note was successfully created." }
        end
    end

    private
        # Only allow a list of trusted parameters through.
        def note_params
            params.require(:note).permit(:_id, :title, :text, :image)
        end
  
  end
  
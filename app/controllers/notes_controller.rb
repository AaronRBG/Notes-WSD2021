class NotesController < ApplicationController
    
    def index
        #will need to filter by user id
        @note = Note.all
    end

    def show
      @note = Note.find(params[:id])
    end 

    def new
        @note = Note.new
    end
    
    def create
        @note = Note.new(Note_params)
        if @note.save
            redirect_to root_path
        else
            render :new
        end
    end

    def destroy
        @note = Note.find(params[:id])
        @note.destroy
        
        redirect_to root_path
    end

    def edit
        #for secure method check if it as user permision to modify
        @note = Note.find(params[:id])
    end

    def update
        @note = Note.find(params[:id])

        if @note.update(Note_params)
          redirect_to @note
        else
          render :edit
        end
    end
    

    private
    def Note_params
      params.require(:note).permit(:title, :text, :date)
    end
end

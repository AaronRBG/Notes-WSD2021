class CollecionsController < ApplicationController
    def index
        if session[:type] == "ADMIN"
            @collections= Collecion.all
        elsif session[:type] == "USER"
            redirect_to collectionNotes_path(:user => session[:user_id])
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

    def collectionNotes
    
    end

end

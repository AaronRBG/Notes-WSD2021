require 'uuidtools'
require 'rails/mongoid'

class Note
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    store_in collection: "notes", database: "NotesWSD2021"

    field :_id, type: String, default: ->{ SecureRandom.uuid.to_s} 
    field :title, type: String
    field :text, type: String
    field :image, type: String, default: ->{ "" }

    validates_presence_of :_id, :title, :text
    validates_uniqueness_of :_id

end
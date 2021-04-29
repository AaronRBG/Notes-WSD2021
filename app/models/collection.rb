require 'uuidtools'
require 'rails/mongoid'

class Collection
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    store_in collection: "collections", database: "NotesWSD2021"

    field :_id, type: String, default: ->{ SecureRandom.uuid.to_s} 
    field :title, type: String

    validates_presence_of :_id, :title
    validates_uniqueness_of :_id

    has_many :notes
    belongs_to :user
end
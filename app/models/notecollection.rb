require 'uuidtools'
require 'rails/mongoid'

class Notecollection
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    store_in collection: "notecollections", database: "NotesWSD2021"

    field :_id, type: String, default: ->{ SecureRandom.uuid.to_s} 
    field :name, type: String
    field :notes, type: Array, default: []

    validates_presence_of :_id, :name
    validates_uniqueness_of :_id

    has_many :userCollections
end
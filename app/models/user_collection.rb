require 'uuidtools'
require 'rails/mongoid'

class UserCollection
  include Mongoid::Document
  store_in collection: "userCollections", database: "NotesWSD2021"
    
  field :_id, type: String, default: ->{ SecureRandom.uuid.to_s} 
  
  belongs_to :collection
  belongs_to :user
end
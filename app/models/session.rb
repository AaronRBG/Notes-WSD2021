require 'uuidtools'
require 'rails/mongoid'

class Session
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  store_in collection: "sessions", database: "NotesWSD2021"

  field :_id, type: String, default: ->{ SecureRandom.uuid.to_s} 
  field :token, type: String, default: ->{ SecureRandom.uuid.to_s} 

  validates_presence_of :_id, :token
  validates_uniqueness_of :_id, :token, :user_id

  belongs_to :user
end
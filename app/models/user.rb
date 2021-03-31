require 'uuidtools'
require 'rails/mongoid'

class User
    
    
   
    PASS_REQ = /\A 
        (?=.{8,})
        (?=.*\d)
        (?=.*\[a-z])
        (?=.*[A-Z])
    /x

    include Mongoid::Document
    include Mongoid::Timestamps::Created
    store_in collection: "users", database: "NotesWSD2021"
    

    field :_id, type: String, default: ->{ SecureRandom.uuid.to_s} 

    field :name, type: String
    field :email, type: String
    field :username, type: String
    field :password, type: String
    field :type, type: String, default: ->{ "USER" }

    validates_presence_of :_id, :name, :email, :username, :password, :type
    validates_uniqueness_of :_id, :username, :email
    validates :username, format: { without: /\s/}
    validates :type, inclusion: { in: %w(USER ADMIN) }
    validates :password, format: PASS_REQ
    has_many :notes
end
require 'uuidtools'
require 'rails/mongoid'

class User
    
    PASS_REQ = /\A 
        (?=.{8,})
        (?=.*\d)
        (?=.*[a-z])
        (?=.*[A-Z])
    /x

    include Mongoid::Document
    include Mongoid::Timestamps::Created
    store_in collection: "users", database: "NotesWSD2021"
    
    field :_id, type: String, default: ->{ SecureRandom.uuid.to_s} 
    field :_id, type: String, :as => :username
    field :name, type: String
    field :email, type: String
    field :password, type: String
    field :type, type: String, default: ->{ "USER" }

    #validates_presence_of :username, :name, :email, :password, :type
    validates_presence_of :name, :email, :password, :type
    #validates_uniqueness_of :_id, :username, :email
    validates_uniqueness_of :_id, :email
    #validates :username, format: { without: /\s/}
    validates :type, inclusion: { in: %w(USER ADMIN) }
    validates :password, format: {with: PASS_REQ}
    validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i
    
    has_one :session
    has_many :userNotes
end
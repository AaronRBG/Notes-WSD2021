class UserNote
  include Mongoid::Document
  store_in collection: "userNotes", database: "NotesWSD2021"
  
  field :_id, type: String, default: ->{ SecureRandom.uuid.to_s} 

  belongs_to :note
  belongs_to :user
end
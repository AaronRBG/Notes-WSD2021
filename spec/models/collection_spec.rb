require 'rails_helper'

RSpec.describe Collection, type: :model do

  context 'validations' do
    it "ensures _id uniqueness" do
      collection = Collection.create!()
      collection.save!
      collection2 = Collection.create(_id: collection._id)
      expect(collection2.save).to eq(false)
      expect(collection.delete).to eq(true)
    end
    it "creates a collection when validations are passed" do
      collection = Collection.create!()
      expect(collection.save!).to eq(true)
      expect(Collection.find(collection._id).delete).to eq(true)
    end
  end

  context 'read, add, remove and delete' do
    subject { @collection }
    before(:all) do
      @collection = Collection.create!()
      @collection.save!
    end

    it "reads a created collection with a given id" do
      expect(Collection.find(@collection._id)).to eq(@collection)
    end

    it "adds a note to a collection" do
      note = Note.create!(title: "titulo", text: "texto")
      note.save!
      Collection.add(collection_id => @collection._id, note_id => note._id)
      @collection = Collection.find(@collection._id)
      expect(@collection.notes.include?(note._id)).to eq(true)
    end

    it "removes a note from a collection" do
      noteID = @collection.notes.first
      Collection.remove(collection_id => @collection._id, note_id => noteID)
      @collection = Collection.find(@collection._id)
      expect(@collection.notes.include?(noteID)).to eq(false)
    end

    it "deletes a created collection with a given id" do
      expect(@collection.delete).to eq(true)
    end
  end

end
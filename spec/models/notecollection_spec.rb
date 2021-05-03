require 'rails_helper'

RSpec.describe Notecollection, type: :model do

  context 'validations' do
    it "ensures _id uniqueness" do
      notecollection = Notecollection.create!(:name => "Titulo")
      notecollection.save!
      notecollection2 = Notecollection.create(_id: notecollection._id)
      expect(notecollection2.save).to eq(false)
      expect(notecollection.delete).to eq(true)
    end
    it "creates a notecollection when validations are passed" do
      notecollection = Notecollection.create!(:name => "Titulo")
      expect(notecollection.save!).to eq(true)
      expect(Notecollection.find(notecollection._id).delete).to eq(true)
    end
  end

  context 'read, add, remove and delete' do
    subject { @notecollection }
    before(:all) do
      @notecollection = Notecollection.create!(:name => "Titulo")
      @notecollection.save!
    end

    it "reads a created notecollection with a given id" do
      expect(Notecollection.find(@notecollection._id)).to eq(@notecollection)
    end

    it "adds a note to a notecollection" do
      note = Note.create!(title: "titulo", text: "texto")
      note.save!
      @notecollection.notes.append(note._id)
      @notecollection.save!
      expect(@notecollection.notes.include?(note._id)).to eq(true)
    end

    it "removes a note from a notecollection" do
      note = Note.find_by(:title => "titulo")
      @notecollection.notes.delete(note._id)
      @notecollection.save!
      note.delete
      expect(@notecollection.notes.include?(note._id)).to eq(false)
    end

    it "deletes a created notecollection with a given id" do
      expect(@notecollection.delete).to eq(true)
    end
  end

end
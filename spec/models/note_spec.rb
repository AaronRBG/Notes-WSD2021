require 'rails_helper'

RSpec.describe Note, type: :model do

  context 'validations' do
    it "ensures the presence of title" do
        note = Note.create(title: "", text: "texto")
        expect(note.save).to eq(false)
    end
    it "ensures the presence of text" do
      note = Note.create(title: "titulo", text: "")
      expect(note.save).to eq(false)
    end
    it "ensures _id uniqueness" do
      note = Note.create!(title: "titulo", text: "texto")
      note.save!
      note2 = Note.create(_id: note._id, title: "titulo", text: "texto")
      expect(note2.save).to eq(false)
      expect(note.delete).to eq(true)
    end
    it "creates a note when validations are passed" do
      note = Note.create!(title: "titulo", text: "texto")
      expect(note.save!).to eq(true)
      expect(Note.find(note._id).delete).to eq(true)
    end
  end

  context 'modification' do
    subject { @note }
    before(:all) do
      @note = Note.create!(title: "titulo", text: "texto")
      @note.save!
    end
    after(:all) do
      @note.delete
    end

    it "permits changing the image of a note" do
        @note.update(:image => "https://media.geeksforgeeks.org/wp-content/cdn-uploads/20190902124355/ruby-programming-language.png")
        expect(@note.image == "https://media.geeksforgeeks.org/wp-content/cdn-uploads/20190902124355/ruby-programming-language.png")
    end
    it "permits changing the title of a note" do
      @note.update(:title => "newTitle")
      expect(@note.title == "newTitle")
    end
    it "permits changing the text of a note" do
      @note.update(:text => "newText")
      expect(@note.title == "newText")
    end
  end

  context 'read and delete' do

    subject { @note }
    before(:all) do
      @note = Note.create!(title: "titulo", text: "texto")
      @note.save!
    end

    it "reads a created note with a given id" do
      expect(Note.find(@note._id)).to eq(@note)
    end
    it "deletes a created note with a given id" do
      expect(@note.delete).to eq(true)
    end
  end

end
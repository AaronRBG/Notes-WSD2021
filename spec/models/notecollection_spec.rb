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

    it "deletes a created notecollection with a given id" do
      expect(@notecollection.delete).to eq(true)
    end
  end

end
require 'rails_helper'
require 'uuidtools'

RSpec.describe Session, type: :model do
  context 'validations' do
    it "ensures the presence of user" do
        session = Session.create(user: "")
        expect(session.save).to eq(false)
    end
    it "ensures user exists" do
      user = User.create(_id: SecureRandom.uuid.to_s)
      session = Session.create(user: user._id)
      bool = User.find(user_id)
      expect(session.save).to eq(bool)
      expect(User.find(user._id).delete).to eq(true)
  end
    it "ensures _id uniqueness" do
      user = User.create!(_id: SecureRandom.uuid.to_s)
      user.save!
      user2 = User.create!(_id: SecureRandom.uuid.to_s)
      user2.save!
      session = Session.create!(user: user._id)
      session.save!
      session2 = Session.create(_id: session._id, user: user2._id)
      expect(session2.save).to eq(false)
      expect(session.delete).to eq(true)
      expect(User.find(user._id).delete).to eq(true)
      expect(User.find(user2._id).delete).to eq(true)
    end
    it "ensures token uniqueness" do
      user = User.create!(_id: SecureRandom.uuid.to_s)
      user.save!
      user2 = User.create!(_id: SecureRandom.uuid.to_s)
      user2.save!
      session = Session.create!(user: user._id)
      session.save!
      session2 = Session.create(token: session.token, user: user2._id)
      expect(session2.save).to eq(false)
      expect(session.delete).to eq(true)
      expect(User.find(user._id).delete).to eq(true)
      expect(User.find(user2._id).delete).to eq(true)
    end
    it "ensures user uniqueness" do
      user = User.create!(_id: SecureRandom.uuid.to_s)
      user.save!
      session = Session.create!(user: user._id)
      session.save!
      session2 = Session.create(user: user._id)
      expect(session2.save).to eq(false)
      expect(session.delete).to eq(true)
      expect(User.find(user._id).delete).to eq(true)
    end
    it "creates a session when validations are passed" do
      user = User.create!(_id: SecureRandom.uuid.to_s)
      user.save!
      session = Session.create!(user: user._id)
      expect(session.save!).to eq(true)
      expect(Session.find(session._id).delete).to eq(true)
      expect(User.find(user._id).delete).to eq(true)
    end
  end

  context 'read and delete' do

    subject { @session }
    before(:all) do
      user = User.create!(_id: SecureRandom.uuid.to_s)
      user.save!
      @session = Session.create!(user: user_id)
      @session.save!
      User.find(user._id).delete
    end

    it "reads a created note with a given id" do
      expect(Note.find(@session._id)).to eq(@session)
    end
    it "deletes a created note with a given id" do
      expect(@session.delete).to eq(true)
    end
  end
end

require 'rails_helper'

RSpec.describe Session, type: :model do
  context 'validations' do
    it "ensures the presence of user" do
        session = Session.create(user: "")
        expect(session.save).to eq(false)
    end
    it "ensures user exists" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      session = Session.create(user: user.username)
      bool = false
      begin
        User.find(user.username)
      rescue
        puts "User does not exist"
      else
        bool = true
      end
      expect(User.find(user.username).delete).to eq(true)
      expect(session.save).to eq(bool)
      expect(session.delete).to eq(true)
  end
    it "ensures _id uniqueness" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      user.save!
      user2 = User.create(username: "username2", name: "name", email: "email2@email.com", password: "password", type: "USER")
      user2.save!
      session = Session.create!(user: user.username)
      session.save!
      session2 = Session.create(_id: session._id, user: user2.username)
      expect(session2.save).to eq(false)
      expect(session.delete).to eq(true)
      expect(User.find(user.username).delete).to eq(true)
      expect(User.find(user2.username).delete).to eq(true)
    end
    it "ensures token uniqueness" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      user.save!
      user2 = User.create(username: "username2", name: "name", email: "email2@email.com", password: "password", type: "USER")
      user2.save!
      session = Session.create!(user: user.username)
      session.save!
      session2 = Session.create(token: session.token, user: user2.username)
      expect(session2.save).to eq(false)
      expect(session.delete).to eq(true)
      expect(User.find(user.username).delete).to eq(true)
      expect(User.find(user2.username).delete).to eq(true)
    end
    it "ensures user uniqueness" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      user.save!
      session = Session.create!(user: user.username)
      session.save!
      session2 = Session.create(user: user.username)
      expect(session2.save).to eq(false)
      expect(session.delete).to eq(true)
      expect(User.find(user.username).delete).to eq(true)
    end
    it "creates a session when validations are passed" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      user.save!
      session = Session.create!(user: user.username)
      expect(session.save!).to eq(true)
      expect(Session.find(session._id).delete).to eq(true)
      expect(User.find(user.username).delete).to eq(true)
    end
  end

  context 'read and delete' do

    subject { @session }
    before(:all) do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      user.save!
      @session = Session.create!(user: user.username)
      @session.save!
      User.find(user.username).delete
    end

    it "reads a created session with a given id" do
      expect(Session.find(@session._id)).to eq(@session)
    end
    it "deletes a created session with a given id" do
      expect(@session.delete).to eq(true)
    end
  end
end

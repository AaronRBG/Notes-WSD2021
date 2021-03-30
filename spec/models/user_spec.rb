require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it "ensures the presence of username" do
        user = User.create(username: "", name: "name", email: "email@email.com", password: "password", type: "USER")
        expect(user.save).to eq(false)
    end
    it "ensures the presence of name" do
      user = User.create(username: "username", name: "", email: "email@email.com", password: "password", type: "USER")
      expect(user.save).to eq(false)
    end
    it "ensures the presence of email" do
      user = User.create(username: "username", name: "name", email: "", password: "password", type: "USER")
      expect(user.save).to eq(false)
    end
    it "ensures the presence of password" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "", type: "USER")
      expect(user.save).to eq(false)
    end
    it "ensures the presence of type" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "")
      expect(user.save).to eq(false)
    end
    it "ensures username uniqueness" do
      user = User.create!(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      user.save!
      user2 = User.create(username: "username", name: "name", email: "email2@email.com", password: "password", type: "USER")
      expect(user2.save).to eq(false)
      expect(user.delete).to eq(true)
    end
    it "ensures email uniqueness" do
      user = User.create!(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      user.save!
      user2 = User.create(username: "username2", name: "name", email: "email@email.com", password: "password", type: "USER")
      expect(user2.save).to eq(false)
      expect(user.delete).to eq(true)
    end
    it "ensures type is valid" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "type")
      bool = (user.type == "USER" OR user.type == "ADMIN")
      expect(user.save).to eq(bool)
    end
    it "ensures email is valid" do
      user = User.create(username: "username", name: "name", email: "email", password: "password", type: "type")
      bool = (user.email.include? "@" AND user.email.include? ".")
      expect(user.save).to eq(bool)
    end
    it "ensures password is valid" do
      user = User.create(username: "username", name: "name", email: "email", password: "password", type: "type")
      bool = (false)
      expect(user.save).to eq(bool)
    end
    it "ensures username is valid" do
      user = User.create(username: "username", name: "name", email: "email", password: "password", type: "type")
      bool = (false)
      expect(user.save).to eq(bool)
    end
    it "creates a user when validations are passed" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      expect(user.save!).to eq(true)
      expect(User.find(user.username).delete).to eq(true)
    end
  end

  context 'read and delete' do

    subject { @user }
    before(:all) do
      @user = User.create(username: "username", name: "name", email: "email@email.com", password: "password", type: "USER")
      @user.save!
    end

    it "reads a created user with a given username" do
      expect(Note.find(@user.username)).to eq(@user)
    end
    it "deletes a created user with a given username" do
      expect(@user.delete).to eq(true)
    end
  end
end

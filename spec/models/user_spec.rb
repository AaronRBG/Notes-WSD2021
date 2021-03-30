require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it "ensures the presence of username" do
        user = User.create(username: "", name: "name", email: "email@email.com", password: "Password1", type: "USER")
        expect(user.save).to eq(false)
    end
    it "ensures the presence of name" do
      user = User.create(username: "username", name: "", email: "email@email.com", password: "Password1", type: "USER")
      expect(user.save).to eq(false)
    end
    it "ensures the presence of email" do
      user = User.create(username: "username", name: "name", email: "", password: "Password1", type: "USER")
      expect(user.save).to eq(false)
    end
    it "ensures the presence of password" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "", type: "USER")
      expect(user.save).to eq(false)
    end
    it "ensures the presence of type" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "Password1", type: "")
      expect(user.save).to eq(false)
    end
    it "ensures username uniqueness" do
      user = User.create!(username: "username", name: "name", email: "email@email.com", password: "Password1", type: "USER")
      user.save!
      user2 = User.create(username: "username", name: "name", email: "email2@email.com", password: "Password1", type: "USER")
      expect(user2.save).to eq(false)
      expect(user.delete).to eq(true)
    end
    it "ensures email uniqueness" do
      user = User.create!(username: "username", name: "name", email: "email@email.com", password: "Password1", type: "USER")
      user.save!
      user2 = User.create(username: "username2", name: "name", email: "email@email.com", password: "Password1", type: "USER")
      expect(user2.save).to eq(false)
      expect(user.delete).to eq(true)
    end
    it "ensures type is valid" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "Password1", type: "type")
      bool = (user.type == "USER") or (user.type == "ADMIN")
      expect(user.save).to eq(bool)
    end
    it "ensures email is valid" do
      user = User.create(username: "username", name: "name", email: "email", password: "Password1", type: "type")
      bool = (user.email.include? "@" and user.email.include? ".")
      expect(user.save).to eq(bool)
    end
    it "ensures password is valid" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "Password1", type: "type")
      expect(user.password =~ /[0-9]/).not_to eq(nil)
      expect(user.password =~ /[a-z]/).not_to eq(nil)
      expect(user.password =~ /[A-Z]/).not_to eq(nil)
      expect(user.password.length >= 8)
    end
    it "ensures username is valid" do
      user = User.create(username: "user name", name: "name", email: "email@email.com", password: "Password1", type: "type")
      bool = not ( user.username.include? " ")
      expect(user.save).to eq(bool)
    end
    it "creates a user when validations are passed" do
      user = User.create(username: "username", name: "name", email: "email@email.com", password: "Password1", type: "USER")
      expect(user.save!).to eq(true)
      expect(User.find(user.username).delete).to eq(true)
    end
  end

  context 'read and delete' do

    subject { @user }
    before(:all) do
      @user = User.create(username: "username", name: "name", email: "email@email.com", password: "Password1", type: "USER")
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

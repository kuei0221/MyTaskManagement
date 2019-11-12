require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  
  it "shoul be valid with factory example" do
    expect(user).to be_valid
  end
  
  context "with user.name" do
    it "should not be nil" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
    end
    
    it "should be unique" do
      create(:user, name: "testing_name")
      user = build(:user, name: "testing_name")
      expect(user).to be_invalid
    end
  end
  
  context "with user.email" do
    it "should not be nil" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
    end
    
    it "should be unique" do
      create(:user, email: "testing_email@email.com")
      user = build(:user, email: "testing_email@email.com")
      expect(user).to be_invalid
    end

    it "should follow format" do
      invalid_emails = %w[ example example@ @example example@test example@test. example@test.com.]
      invalid_emails.each do |email|
        user = build(:user, email: email)
        expect(user).to be_invalid
      end
    end
  end

  context "with user.password" do
    it "should not be nil" do
      user = build(:user, password: nil)
      expect(user).to be_invalid
    end

    it "should be longer than 8 chr" do
      user = build(:user, password: "a"*7, password_confirmation: "a"*7)
      expect(user).to be_invalid
    end

    context "when user#create" do
      it "should save it confirmation matched" do
        user = build(:user, password: "testing_password", password_confirmation: "testing_password")
        expect(user.save).to be true
      end
      
      it "should not save it confirmation did not match" do
        user = build(:user, password: "testing_password", password_confirmation: "inncorrect_password")
        expect(user.save).to be false
      end
    end
  end

  context "with user.missions" do
    it "should be destroy when user destroy" do
      user = create(:user_with_missions)
      expect(Mission.where(user: user)).not_to be_empty
      user.destroy
      expect(Mission.where(user: user)).to be_empty
    end
  end

end

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }
  
  it "should be valid with factory example" do
    expect(user).to be_valid
    expect(user.save).to be true
    expect(user).to be_valid
  end
  
  describe "#name" do
    context "with nil name" do
      it "should be invalid" do
        user = build(:user, name: nil)
        expect(user).to be_invalid
      end
    end
    context "with duplicate name" do
      it "should be invalid" do
        create(:user, name: "testing_name")
        user = build(:user, name: "testing_name")
        expect(user).to be_invalid
      end
    end
  end
  
  describe "#eamil" do
    context "with nil email" do
      it "should be invalid" do
        user = build(:user, email: nil)
        expect(user).to be_invalid
      end
    end
    
    context "with duplicate email" do
      it "should be invalid" do
        create(:user, email: "testing_email@email.com")
        user = build(:user, email: "testing_email@email.com")
        expect(user).to be_invalid
      end
    end
    
    context "with irregular email" do
      it "should be invalid" do
        invalid_emails = %w[ example example@ @example example@test example@test. example@test.com.]
        invalid_emails.each do |email|
          user = build(:user, email: email)
          expect(user).to be_invalid
        end
      end
    end

    context "with different case email" do
      it "should not be case sensitive" do
        create(:user, email: "tESTing_eMaiL@email.COM")
        user = build(:user, email: "Testing_Email@eMAIL.com")
        expect(user).to be_invalid
      end

      it "should store in downcase" do
        user = create(:user, email: "tESTing_eMaiL@email.COM")
        expect(user.email).to eq "testing_email@email.com"
      end
    end
  end

  describe "#password" do
    context "with nil password" do
      it "should be invalid " do
        user = build(:user, password: nil)
        expect(user).to be_invalid
      end
    end
    
    context "with password shorter than 8 chr" do
      it "should be invalid " do
        user = build(:user, password: "a"*7, password_confirmation: "a"*7)
        expect(user).to be_invalid
      end
    end

  end

  describe "#password_confirmation" do
    context "when user create" do
      context "when confirmation is blank" do
        it "should be false" do
          user = build(:user, password: "testing_password", password_confirmation: "")

          expect(user.save).to be false
        end
      end
      context "when confirmation matched" do
        it "should save" do
          user = build(:user, password: "testing_password", password_confirmation: "testing_password")
          expect(user.save).to be true
        end
      end
      context "when confirmation not matched" do
        it "should not save" do
          user = build(:user, password: "testing_password", password_confirmation: "inncorrect_password")
          expect(user.save).to be false
        end
      end
    end
    
    context "when user update password & password confirmation" do
      context "when confirmation is blank" do
        it "should be false" do
          expect(user.update(password: "new_password", password_confirmation: "")).to be false
        end
      end
      context "when confirmation matched" do
        it "should be true" do
          expect(user.update(password: "new_password", password_confirmation: "new_password")).to be true
        end
      end
      context "when confirmation not matched" do
        it "should be false" do
          expect(user.update(password: "new_password", password_confirmation: "wrong_password")).to be false
        end
      end
      context "when confirmation is blank but password not" do
        it "should be false" do
          expect(user.update(password: nil, password_confirmation: "wrong_password")).to be false
        end
      end
    end
  end

  describe "#missions" do
    context "when destroy user having missions" do
      it "should destroy user's missions as well" do
        user = create(:user_with_missions)
        expect(Mission.where(user: user)).not_to be_empty
        user.destroy
        expect(Mission.where(user: user)).to be_empty
      end
    end
  end

  describe "#missions_count" do
    let!(:user) { create(:user_with_missions, missions_count: 10) }
    it "should give exact missions number" do
      expect(user.missions_count).to eq 10
    end
    context "when create new missions" do
      it "should update immediately " do
        create(:mission, user: user)
        expect(user.missions_count).to eq 11
      end
    end
  end

  describe "#role" do
    context "with admin user" do
      it "can be normal" do
        user = build(:user, :admin, :normal)
        expect(user).to be_valid
      end
      it "can be administrator" do
        user = build(:user, :admin, :administrator)
        expect(user).to be_valid
      end
    end
    
    context "with not admin user " do
      it "can be normal" do
        user = build(:user, :normal)
        expect(user).to be_valid
      end
      it "cannot be administrator" do
        user = build(:user, :normal, :administrator)
        expect(user).to be_invalid
      end
    end
  end

  describe "#switch_role" do
    context "when admin user" do
      
      it "should switch role from administrator to normal" do
        user = create(:user, :admin, :administrator)
        user.switch_role
        expect(user.role).to eq "normal"
      end
      it "should switch role from normal to administrator" do
        user = create(:user, :admin, :normal)
        user.switch_role
        expect(user.role).to eq "administrator"
      end
    end
    
    context "when not admin user " do
      it "should return false " do
        user = create(:user)
        expect(user.switch_role).to be false
      end
    end
  end

  describe "::cannot_downgrade_last_admin" do
    context "when downgrade last admin user" do
      it "should be false" do
        expect(User.search_admin(true).size).to eq 1
        expect(admin_user.update(admin: false)).to be false
      end
    end
  end
  
  describe "::cannot_destroy_last_admin" do
    context "when destroy last admin user" do
      it "should be false" do
        expect(User.search_admin(true).size).to eq 1
        expect(admin_user.destroy).to be false
      end
    end
  end

  describe "::search_name" do
    context "when search with given string" do
      it "should return users which name include string" do
        user1 = create(:user, name: "testing_name")
        user2 = create(:user, name: "test_name")
        user3 = create(:user, name: "another_testname")
        expect(User.search_name("test")).to include user1
        expect(User.search_name("test")).to include user2
        expect(User.search_name("test")).to include user3
      end
    end
  end
  
  describe "::search_email" do
    context "when search with given string" do
      it "should return users which email include string and not case sensitive" do
        user1 = create(:user, email: "tesTINg_name@email.com")
        user2 = create(:user, email: "TEst_name@email.com")
        user3 = create(:user, email: "another_TeStname@email.com")
        expect(User.search_email("test")).to include user1
        expect(User.search_email("Test")).to include user2
        expect(User.search_email("teST")).to include user3
      end
    end
  end

  describe "::search_admin" do
    context "when search with true" do
      it "should return all admin user" do
        expect(User.search_admin(true).pluck(:admin).all? true).to be true
      end
    end
    context "when search with false" do
      it "should retunr all not admin user" do
        expect(User.search_admin(false).pluck(:admin).all? false).to be true
      end
    end
  end

  describe "::order_by_column" do
    before do
      create_list(:user, 5)
      create_list(:user, 3, :admin, :administrator)
      create(:user_with_missions, missions_count: 5)
      create(:user_with_missions, missions_count: 3)
      create(:user_with_missions, missions_count: 1)
    end
    context "with column: created_at, direction: asc" do
      it "should sort the oldest user first " do
        users = User.order_by_column(:created_at, :asc)
        expect(users[0].created_at).to be < users[1].created_at
        expect(users[1].created_at).to be < users[2].created_at
        expect(users[2].created_at).to be < users[3].created_at
      end
    end
    context "with column: created_at, direction: desc" do
      it "should sort the newest user first " do
        users = User.order_by_column(:created_at, :desc)
        expect(users[0].created_at).to be > users[1].created_at
        expect(users[1].created_at).to be > users[2].created_at
        expect(users[2].created_at).to be > users[3].created_at
      end
    end
    context "with column: role, direction: asc" do
      it "should sort the normal role first " do
        users = User.order_by_column(:role, :asc)
        expect(users[0].role).to eq "normal"
        expect(users[1].role).to eq "normal"
        expect(users[2].role).to eq "normal"
        expect(users[-1].role).to eq "administrator"
        expect(users[-2].role).to eq "administrator"
        expect(users[-3].role).to eq "administrator"
      end
    end
    context "with column: role, direction: desc" do
      it "should sort the administrator role first " do
        users = User.order_by_column(:role, :desc)
        expect(users[1].role).to eq "administrator"
        expect(users[2].role).to eq "administrator"
        expect(users[0].role).to eq "administrator"
        expect(users[-1].role).to eq "normal"
        expect(users[-2].role).to eq "normal"
        expect(users[-3].role).to eq "normal"
      end
    end
    context "with column: admin, direction: asc" do
      it "should sort the none admin user first " do
        users = User.order_by_column(:admin, :asc)
        expect(users[0].admin).to eq false
        expect(users[1].admin).to eq false
        expect(users[2].admin).to eq false
        expect(users[-1].admin).to eq true
        expect(users[-2].admin).to eq true
        expect(users[-3].admin).to eq true
      end
    end
    context "with column: admin, direction: desc" do
      it "should sort the admin user first " do
        users = User.order_by_column(:admin, :desc)
        expect(users[0].admin).to eq true
        expect(users[1].admin).to eq true
        expect(users[2].admin).to eq true
        expect(users[-1].admin).to eq false
        expect(users[-2].admin).to eq false
        expect(users[-3].admin).to eq false
      end
    end
    context "with column: missions_count, direction: asc" do
      it "should sort the user with lower missions_count first " do
        users = User.order_by_column(:missions_count, :asc)
        expect(users[0].missions_count).to be <= users[1].missions_count
        expect(users[1].missions_count).to be <= users[2].missions_count
        expect(users[2].missions_count).to be <= users[3].missions_count
        expect(users[-4].missions_count).to be <= users[-3].missions_count
        expect(users[-3].missions_count).to be <= users[-2].missions_count
        expect(users[-2].missions_count).to be <= users[-1].missions_count
      end
    end
    context "with column: missions_count, direction: desc" do
      it "should sort the user with higher missions_count first " do
        users = User.order_by_column(:missions_count, :desc)
        expect(users[0].missions_count).to be >= users[1].missions_count
        expect(users[1].missions_count).to be >= users[2].missions_count
        expect(users[2].missions_count).to be >= users[3].missions_count
        expect(users[-4].missions_count).to be >= users[-3].missions_count
        expect(users[-3].missions_count).to be >= users[-2].missions_count
        expect(users[-2].missions_count).to be >= users[-1].missions_count
      end
    end
  end

  describe "::filterable_column" do
    it "should return array of assigned column in symbol type" do
      expect(User.filterable_column.is_a? Array).to be true
      expect(User.filterable_column.all? Symbol).to be true
    end
    
    it "should include name, email, admin" do
      expect(User.filterable_column).to include :name
      expect(User.filterable_column).to include :email
      expect(User.filterable_column).to include :admin
    end

    it "should have search scope for each column" do
      expect(User.public_methods).to include :search_name
      expect(User.public_methods).to include :search_email
      expect(User.public_methods).to include :search_admin
    end
  end

  describe "::filter" do
    before do
      create_list(:user, 5)
      create_list(:user, 3, :admin, :administrator)
    end
    context "with given params hash" do
      it "should filter the user" do
        query = {name: "", email: "", admin: true, role: "normal", not_exits_key: "error"}
        expect(User.filter(query).pluck(:admin).none?(false)).to be true
        expect(User.filter(query).pluck(:role).any?("administrator")).to be true
        expect(User.filter(query).pluck(:role).any?("normal")).to be true
      end
    end

    context "with empty hash" do
      it "should return entire user" do
        query = {}
        expect(User.filter(query)).to eq User.all
      end
    end
  end

end

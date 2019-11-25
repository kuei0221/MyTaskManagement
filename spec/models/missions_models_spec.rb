require "rails_helper"

RSpec.describe Mission, type: :model do
  let(:mission) { build(:mission) }
<<<<<<< HEAD
  context "with factory-data " do
    it "should be valid" do
      expect(mission).to be_valid
      expect(mission.save).to be true
    end
  end
  describe "#name" do
    context "when nil" do
=======
  describe "mission.name" do
    context "with emtpy name" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be invalid" do
        mission = build(:mission, name: nil)
        expect(mission).to be_invalid
      end
    end

<<<<<<< HEAD
    context "when less than 8 chr" do
=======
    context "with name less than 8 chr" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be invald" do
        mission = build(:mission, name: "a"*7)
        expect(mission).to be_invalid
      end
    end

<<<<<<< HEAD
    context "when more that 48 chr" do
=======
    context "with name more that 48 chr" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be invalid" do
        mission = build(:mission, name: "a"*49)
        expect(mission).to be_invalid
      end
    end
<<<<<<< HEAD
  end

  describe "#content" do
    context "when nil" do
=======

    context "with valid name" do
      it "should be valid" do
        expect(mission).to be_valid
      end
    end
  end

  describe "mission.content" do

    context "with valid content" do
      it "should be valid" do
        expect(mission).to be_valid
      end
    end

    context "with empty content" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be invalid" do
        mission = build(:mission, content: nil)
        expect(mission).to be_invalid
      end
    end
    
<<<<<<< HEAD
    context "when less than 8 chr" do
=======
    context "with content less than 8 chr" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be invalid" do
        mission = build(:mission, content: "a"*7)
        expect(mission).to be_invalid
      end
    end
    
<<<<<<< HEAD
    context "when more than 254 chr" do
=======
    context "with content more than 254 chr" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be invalid" do
        mission = build(:mission, content: "a"*255)
        expect(mission).to be_invalid
      end
    end
  end

<<<<<<< HEAD
  describe "#deadline" do
    context "when nil" do
=======
  describe "mission.deadline" do
    context "with valid date" do
      it "should be valid " do
        expect(mission).to be_valid
      end
    end

    context "without provide date" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be valid" do
        mission = build(:mission, deadline: nil)
        expect(mission).to be_valid
      end
    end

<<<<<<< HEAD
    context "when date is in past" do
      it "should be invalid" do
=======
    context "with past date" do
      it "should be fail" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
        mission = build(:mission, deadline: Faker::Date.backward(days: 10))
        expect(mission).to be_invalid
      end
    end

<<<<<<< HEAD
    context "when it is earlier than its create date" do
      it "should be invalid" do
=======
    context "with date earlier than create date" do
      it "should be fail" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
        mission = build(:mission, created_at: DateTime.now, deadline: (DateTime.now - 10))
        expect(mission).to be_invalid
      end
    end

  end

<<<<<<< HEAD
  describe "#work_state" do
    context "when create new mission" do
      it "should be waiting by default" do
        mission = Mission.new
        expect(mission.work_state).to eq "waiting" 
      end
    end
    context "with correct work state" do
=======
  describe "mission.work_state" do
    context "with exist work state" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be valid with waiting" do
        mission = build(:mission, :waiting)
        expect(mission).to be_valid
      end
      it "should be valid with progressing" do
        mission = build(:mission, :progressing)
        expect(mission).to be_valid
      end
      it "should be valid with completed" do
        mission = build(:mission, :completed)
        expect(mission).to be_valid
      end
<<<<<<< HEAD

      it "should be valid with 0 which equal waiting" do
        mission = build(:mission, work_state: 0)
        expect(mission).to be_valid
        expect(mission.work_state).to eq "waiting"
      end
      it "should be valid with 1 which equal progressing" do
        mission = build(:mission, work_state: 1)
        expect(mission).to be_valid
        expect(mission.work_state).to eq "progressing"
      end
      it "should be valid with 2 which equal completed" do
        mission = build(:mission, work_state: 2)
        expect(mission).to be_valid
        expect(mission.work_state).to eq "completed"
      end
    end

    context "with incorrect work-state" do
=======
    end

    context "with invalid work-state" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be invalid with not used state" do
        expect{build(:mission, work_state: "not_used_state")}.to raise_error(ArgumentError, /is not a valid work_state/)
        expect{build(:mission, work_state: 3)}.to raise_error(ArgumentError, /is not a valid work_state/)
      end

      it "should be invalid with nil" do
        mission = build(:mission, work_state: nil)
        expect(mission).to be_invalid
      end
    end

    context "with #wait" do
      it "should switch work_state to waiting when it is progressing" do
        mission = create(:mission, :progressing)
        expect(mission.wait).to be true
      end
      
      it "should not switch work_state if the state is completed" do
        mission = create(:mission, :completed)
        expect(mission.wait).to be false
      end
    end
    
    context "with #progress" do
      it "should switch work state to progressing when it is waiting" do
        mission = create(:mission, :waiting)
        expect(mission.progress).to be true
      end
      
      it "should not switch work_state if the state is completed" do
        mission = create(:mission, :completed)
        expect(mission.progress).to be false
      end
    end
    
    context "with #complete" do
      it "should switch work state to completed when it is progressing" do
        mission = create(:mission, :progressing)
        expect(mission.complete).to be true
      end
      
      it "should no switch work state if the state is waiting" do
        mission = create(:mission, :waiting)
        expect(mission.complete).to be false
      end
    end

  end

<<<<<<< HEAD
  describe "::search_name" do
    context "when searching with string" do
      let!(:m1) { create(:mission, :waiting, name: "test example") }
      let!(:m2) { create(:mission, :progressing, name: "TESTING EXAMPLE") }
      let!(:m3) { create(:mission, :completed, name: "Tested Example") }
      it "should find the mission with given string" do
=======
  describe "::search scope" do
    before do
      create_list(:mission, 2, :waiting)
      create_list(:mission, 3, :progressing)
      create_list(:mission, 4, :completed)
    end
    
    context "with search_name" do
      let!(:m1) { create(:mission, :waiting, name: "test example") }
      let!(:m2) { create(:mission, :progressing, name: "TESTING EXAMPLE") }
      let!(:m3) { create(:mission, :completed, name: "Tested Example") }
      it "should find the mission include given name" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
        missions = Mission.search_name("Test")
        expect(missions.include?(m1)).to be true
        expect(missions.include?(m2)).to be true
        expect(missions.include?(m3)).to be true
      end
    end
<<<<<<< HEAD
  end

  describe "::search_work_state" do
    before do
      create_list(:mission, 2, :waiting)
      create_list(:mission, 3, :progressing)
      create_list(:mission, 4, :completed)
    end
    context "with correct state" do
      it "should find all waiting missions" do
        missions = Mission.search_work_state("waiting")
        expect(missions.pluck(:work_state).all? "waiting").to be true
        expect(missions.size).to eq 2
      end
      it "should find all progressing missions" do
        missions = Mission.search_work_state("progressing")
        expect(missions.pluck(:work_state).all? "progressing").to be true
        expect(missions.size).to eq 3
      end
      it "should find all completed missions" do
        missions = Mission.search_work_state("completed")
        expect(missions.pluck(:work_state).all? "completed").to be true
        expect(missions.size).to eq 4
      end
    end
  end


  describe "#priority" do
    before do
      create_list(:mission, 3, :low_priority)
      create_list(:mission, 2, :medium_priority)
      create_list(:mission, 1, :high_priority)
    end
    context "when create new mission" do
      it "should be low by default" do
        mission = Mission.new
        expect(mission.priority).to eq "low"
      end
    end
    context "with correct priority" do
      it "should be valid with low" do
        mission = build(:mission, :low_priority)
        expect(mission).to be_valid
      end
      it "should be valid with medium" do
        mission = build(:mission, :medium_priority)
        expect(mission).to be_valid
      end
      it "should be valid with high" do
        mission = build(:mission, :high_priority)
        expect(mission).to be_valid
      end
      it "should be valid with 0 which equal low" do
        mission = build(:mission, priority: 0)
        expect(mission).to be_valid
      end
      it "should be valid with 1 which equal medium" do
        mission = build(:mission, priority: 1)
        expect(mission).to be_valid
      end
      it "should be valid with 2 which equal high" do
        mission = build(:mission, priority: 2)
        expect(mission).to be_valid
      end
    end
    context "with invalid priority" do
      it "should be invalid with not userd string" do
=======
    
    context "with search_by_work_state" do
      it "should find the correct number of mission with match state" do
        missions = Mission.search_work_state(:waiting)
        expect(missions.size).to eq(2)
        missions = Mission.search_work_state(:progressing)
        expect(missions.size).to eq(3)
        missions = Mission.search_work_state(:completed)
        expect(missions.size).to eq(4)
      end
    end
    
  end

  describe "mission.priority" do
    it "should be valid with default data" do
      expect(mission).to be_valid
    end
    context "with invalid priority" do
      it "should be invalid with string" do
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
        expect{ build(:mission, priority: "super high")}.to raise_error(ArgumentError, /is not a valid priority/)
      end
      it "should be invalid with unused level" do
        expect{ build(:mission, priority: 10)}.to raise_error(ArgumentError, /is not a valid priority/)
      end
<<<<<<< HEAD
=======

>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
      it "should be invalid with nil" do
        mission = build(:mission, priority: nil)
        expect(mission).to be_invalid
      end
    end

    context "with #higher_priority" do
      it "should increase from low to medium" do
        mission = create(:mission, :low_priority)
        expect{mission.higher_priority}.to change{ mission.priority}.from("low").to("medium")
      end
      it "should increase from medium to high" do
        mission = create(:mission, :medium_priority)
        expect{mission.higher_priority}.to change{ mission.priority}.from("medium").to("high")
      end
      it "should not increase when it is high" do
        mission = create(:mission, :high_priority)
        expect{mission.higher_priority}.not_to change{ mission.priority}
      end
    end

    context "with #lower_priority" do
      it "should decrease from high to medium" do
        mission = create(:mission, :high_priority)
        expect{ mission.lower_priority }.to change{ mission.priority }.from("high").to("medium")
      end
      it "should decrease from medium to low" do
        mission = create(:mission, :medium_priority)
        expect{ mission.lower_priority }.to change{ mission.priority }.from("medium").to("low")
      end
      it "should not decrease when it is low" do
        mission = create(:mission, :low_priority)
        expect{ mission.lower_priority }.not_to change{ mission.priority }
      end
    end
<<<<<<< HEAD
  end

  describe "::search_priority" do
    before do
      create_list(:mission, 3, :low_priority)
      create_list(:mission, 2, :medium_priority)
      create_list(:mission, 1, :high_priority)
    end
    context "when corret priority" do
      it "should find all low priority missions" do
        missions = Mission.search_priority("low")
        expect(missions.pluck(:priority).all? "low").to be true
        expect(missions.size).to eq 3
      end
      it "should find all medium priority missions" do
        missions = Mission.search_priority("medium")
        expect(missions.pluck(:priority).all? "medium").to be true
        expect(missions.size).to eq 2
      end
      it "should find all high priority missions" do
        missions = Mission.search_priority("high")
        expect(missions.pluck(:priority).all? "high").to be true
        expect(missions.size).to eq 1
      end

    end
  end

  describe "#user_id" do 
    it "should not be nil" do
      mission = build(:mission, user_id: nil)
      expect(mission).to be_invalid
    end
    
    it "should be valid id" do
      mission = build(:mission, user_id: 999999999)
      expect(mission).to be_invalid
    end
  end

  describe "::search_user_id" do
    it "should find same user's missions" do
      user = create(:user_with_missions, missions_count: 5)
      missions = Mission.search_user_id(user.id)
      expect(missions.pluck(:user_id).all? user.id).to be true
      expect(missions.size).to eq 5
    end
  end

  describe "::filterable_column" do
    it "should return array of assigned column in symbol type" do
      expect(Mission.filterable_column.is_a? Array).to be true
      expect(Mission.filterable_column.all? Symbol).to be true
    end
    
    it "should include name, user_id, work_state, priority" do
      expect(Mission.filterable_column).to include :name
      expect(Mission.filterable_column).to include :user_id
      expect(Mission.filterable_column).to include :work_state
      expect(Mission.filterable_column).to include :priority
    end

    it "should have search scope for each column" do
      expect(Mission.public_methods).to include :search_name
      expect(Mission.public_methods).to include :search_user_id
      expect(Mission.public_methods).to include :search_work_state
      expect(Mission.public_methods).to include :search_priority
    end
  end

  describe "::filter" do
    before do
      create_list(:mission, 20)
    end
    context "with given params hash" do
      it "should filter low priority and progressing state mission" do
        query = {name: "", user_id: "", work_state: "progressing", priority: "low", not_exits_key: "error"}
        missions = Mission.filter(query)
        expect(missions.pluck(:priority).all? "low").to be true
        expect(missions.pluck(:work_state).all? "progressing").to be true
      end
      it "should filter user's all completed missions" do
        query = {name: "", user_id: User.first.id, work_state: "completed", priority: "", not_exits_key: "error"}
        missions = Mission.filter(query)
        expect(missions.pluck(:user_id).all? User.first.id).to be true
        expect(missions.pluck(:work_state).all? "completed").to be true
      end
      it "should return entire mission" do
        query = {name: "", user_id: "", work_state: "", priority: "", not_exits_key: "error"}
        expect(Mission.filter(query)).to eq Mission.all
      end
    end

    context "with empty hash" do
      it "should return entire user" do
        query = {}
        expect(Mission.filter(query)).to eq Mission.all
      end
    end
  end

  describe "::order_by_column" do
    before do
      create_list(:mission, 20)
    end

    context "with created_at" do
      it "should show newer first in desc" do
        missions = Mission.order_by_column(:created_at, :desc).pluck(:created_at)
        expect(missions[0]).to be >= missions[1]
        expect(missions[1]).to be >= missions[2]
        expect(missions[2]).to be >= missions[3]
        
      end
      
      it "should show older first in asc" do
        missions = Mission.order_by_column(:created_at, :asc).pluck(:created_at)
        expect(missions[0]).to be <= missions[1]
        expect(missions[1]).to be <= missions[2]
        expect(missions[2]).to be <= missions[3]
      end
      
    end
    
    context "with user_id" do
      it "should show bigger id first in desc" do
        missions = Mission.order_by_column(:user_id, :desc).pluck(:user_id)
        expect(missions[0]).to be >= missions[1]
        expect(missions[1]).to be >= missions[2]
        expect(missions[2]).to be >= missions[3]
      end
      it "should show smaller id first in asc" do
        missions = Mission.order_by_column(:user_id, :asc).pluck(:user_id)
        expect(missions[0]).to be <= missions[1]
        expect(missions[1]).to be <= missions[2]
        expect(missions[2]).to be <= missions[3]
      end
    end
    
    context "with work_state" do
      it "should show completed first in desc" do
        missions = Mission.order_by_column(:work_state, :desc).pluck(:work_state)
        expect(missions[0]).to be >= missions[1]
        expect(missions[1]).to be >= missions[2]
        expect(missions[2]).to be >= missions[3]
      end
      it "should show waiting first in asc" do
        missions = Mission.order_by_column(:work_state, :asc).pluck(:work_state)
        expect(missions[0]).to be <= missions[1]
        expect(missions[1]).to be <= missions[2]
        expect(missions[2]).to be <= missions[3]
      end
    end
    
    context "with priority" do
      it "should show high priority first in desc" do
        missions = Mission.order_by_column(:priority, :desc).pluck(:priority)
        expect(missions[0]).to be >= missions[1]
        expect(missions[1]).to be >= missions[2]
        expect(missions[2]).to be >= missions[3]
      end
      it "should show low priority first in asc" do
        missions = Mission.order_by_column(:priority, :asc).pluck(:priority)
        expect(missions[0]).to be <= missions[1]
        expect(missions[1]).to be <= missions[2]
        expect(missions[2]).to be <= missions[3]
      end
    end
    
    context "with deadline" do
      it "should show farest deadline first in desc" do
        missions = Mission.order_by_column(:deadline, :desc).pluck(:deadline)
        expect(missions[0]).to be >= missions[1]
        expect(missions[1]).to be >= missions[2]
        expect(missions[2]).to be >= missions[3]
      end
      it "should show nearest deadline first in asc" do
        missions = Mission.order_by_column(:deadline, :asc).pluck(:deadline)
        expect(missions[0]).to be <= missions[1]
        expect(missions[1]).to be <= missions[2]
        expect(missions[2]).to be <= missions[3]
      end
    end

  end
=======

  end

>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e

end
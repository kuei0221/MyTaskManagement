require "rails_helper"

RSpec.describe Mission, type: :model do
  let(:mission) { build(:mission) }
  describe "mission.name" do
    context "with emtpy name" do
      it "should be invalid" do
        mission = build(:mission, name: nil)
        expect(mission).to be_invalid
      end
    end

    context "with name less than 8 chr" do
      it "should be invald" do
        mission = build(:mission, name: "a"*7)
        expect(mission).to be_invalid
      end
    end

    context "with name more that 48 chr" do
      it "should be invalid" do
        mission = build(:mission, name: "a"*49)
        expect(mission).to be_invalid
      end
    end

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
      it "should be invalid" do
        mission = build(:mission, content: nil)
        expect(mission).to be_invalid
      end
    end
    
    context "with content less than 8 chr" do
      it "should be invalid" do
        mission = build(:mission, content: "a"*7)
        expect(mission).to be_invalid
      end
    end
    
    context "with content more than 254 chr" do
      it "should be invalid" do
        mission = build(:mission, content: "a"*255)
        expect(mission).to be_invalid
      end
    end
  end

  describe "mission.deadline" do
    context "with valid date" do
      it "should be valid " do
        expect(mission).to be_valid
      end
    end

    context "without provide date" do
      it "should be valid" do
        mission = build(:mission, deadline: nil)
        expect(mission).to be_valid
      end
    end

    context "with past date" do
      it "should be fail" do
        mission = build(:mission, deadline: Faker::Date.backward(days: 10))
        expect(mission).to be_invalid
      end
    end

    context "with date earlier than create date" do
      it "should be fail" do
        mission = build(:mission, created_at: DateTime.now, deadline: (DateTime.now - 10))
        expect(mission).to be_invalid
      end
    end

  end

  describe "mission.work_state" do
    context "with exist work state" do
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
    end

    context "with invalid work-state" do
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
        missions = Mission.search_name("Test")
        expect(missions.include?(m1)).to be true
        expect(missions.include?(m2)).to be true
        expect(missions.include?(m3)).to be true
      end
    end
    
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
        expect{ build(:mission, priority: "super high")}.to raise_error(ArgumentError, /is not a valid priority/)
      end
      it "should be invalid with unused level" do
        expect{ build(:mission, priority: 10)}.to raise_error(ArgumentError, /is not a valid priority/)
      end

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

  end


end
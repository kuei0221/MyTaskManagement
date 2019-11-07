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
        mission = build(:mission, work_state: "not_used_state")
        expect(mission).to be_invalid
      end

      it "should be invalid with nil" do
        mission = build(:mission, work_state: nil)
        expect(mission).to be_invalid
      end
    end

    context "with ::wait" do
      it "should switch work_state to waiting when it is progressing" do
        mission = create(:mission, :progressing)
        expect(mission.wait).to be true
      end
      
      it "should not switch work_state if the state is completed" do
        mission = create(:mission, :completed)
        expect(mission.wait).to be false
      end
    end
    
    context "with ::progress" do
      it "should switch work state to progressing when it is waiting" do
        mission = create(:mission, :waiting)
        expect(mission.progress).to be true
      end
      
      it "should not switch work_state if the state is completed" do
        mission = create(:mission, :completed)
        expect(mission.progress).to be false
      end
    end
    
    context "with ::completed" do
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

end
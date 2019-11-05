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

  describe "default_scope" do
    before { create_list(:mission, 5) }
    it "should sort mission in asc time order" do
      expect(Mission.first.created_at).to be < Mission.second.created_at
      expect(Mission.second.created_at).to be < Mission.third.created_at
      expect(Mission.third.created_at).to be < Mission.last.created_at
    end
  end
end
require "rails_helper"

RSpec.feature "mission", type: :feature do

  before do
    create_list(:mission, 4)
    # page.driver.header 'Accept-Language', locale
    # I18n.locale = locale
  end
  let!(:mission) {create(:mission)}
  # let(:locale) { :en }

  scenario "with mission list" do
    visit root_path
    expect(page).to have_current_path root_path
    expect(page).to have_link("New Mission")
    expect(page).to have_css("#missions_table")
    expect(page).to have_content("Name")
    expect(page).to have_content("Content")
    expect(page).to have_css(".mission", count: 5)
  end
  
  scenario "when viewing specific mission" do
    visit mission_path(mission.id)
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_content(mission.name)
    expect(page).to have_content(mission.content)
    expect(page).to have_link("Edit Mission")
    expect(page).to have_link("Delete Mission")
    expect(page).to have_link("Back to Missions list")
  end
  
  scenario "when creating new mission" do
    visit new_mission_path
    expect(page).to have_current_path new_mission_path
    fill_in "Name", with: "Testing Mission name"
    fill_in "Content", with: "Testing Mission Content"
    click_button "Create!"
    expect(page).to have_current_path root_path
    expect(page).to have_text "Create New Mission Success."
    expect(page).to have_content "Testing Mission name"
    expect(page).to have_content "Testing Mission Content"
    expect(page).to have_css(".mission", count: 6)
  end
  
  scenario "when updating mission" do
    visit edit_mission_path(mission.id)
    expect(page).to have_current_path edit_mission_path(mission.id)
    fill_in "Name", with: "Updating Mission name"
    fill_in "Content", with: "Updating Mission Content"
    click_button "Update!"
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_text "Update Success."
    expect(page).to have_content "Updating Mission name"
    expect(page).to have_content "Updating Mission Content"
  end
  
  scenario "when deleting mission" do
    visit mission_path(mission.id)
    expect(page).to have_link("Delete Mission")
    click_link "Delete Mission"
    expect(page).to have_text "Delete Mission Success!"
    expect(page).to have_current_path root_path
    expect(page).to have_css(".mission", count: 4)
  end

end
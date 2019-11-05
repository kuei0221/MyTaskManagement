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
    expect(page).to have_link(I18n.t("missions.create_button"))
    expect(page).to have_css("#missions_table")
    expect(page).to have_content(I18n.t("missions.table.name"))
    expect(page).to have_content(I18n.t("missions.table.content"))
    expect(page).to have_content(I18n.t("missions.table.created_at"))
    expect(page).to have_css(".mission", count: 5)
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
  end
  
  scenario "when viewing specific mission" do
    visit mission_path(mission.id)
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_content(mission.name)
    expect(page).to have_content(mission.content)
    expect(page).to have_content(mission.created_at.to_s(:short))
    expect(page).to have_link(I18n.t("missions.edit_button"))
    expect(page).to have_link(I18n.t("missions.destroy_button"))
    expect(page).to have_link(I18n.t("missions.return_button"))
  end
  
  scenario "when creating new mission" do
    visit new_mission_path
    expect(page).to have_current_path new_mission_path
    fill_in "mission_name", with: "Testing Mission name"
    fill_in "mission_content", with: "Testing Mission Content"
    click_button I18n.t("missions.table.create")
    expect(page).to have_current_path root_path
    expect(page).to have_text I18n.t("missions.create.success")
    expect(page).to have_content "Testing Mission name"
    expect(page).to have_content "Testing Mission Content"
    expect(page).to have_css(".mission", count: 6)
  end
  
  scenario "when updating mission" do
    visit edit_mission_path(mission.id)
    expect(page).to have_current_path edit_mission_path(mission.id)
    fill_in "mission_name", with: "Updated Mission name"
    fill_in "mission_content", with: "Updated Mission Content"
    click_button I18n.t("missions.table.update")
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_text I18n.t("missions.update.success")
    expect(page).to have_content "Updated Mission name"
    expect(page).to have_content "Updated Mission Content"
  end
  
  scenario "when deleting mission" do
    visit mission_path(mission.id)
    expect(page).to have_link(I18n.t("missions.destroy_button"))
    click_link I18n.t("missions.destroy_button")
    expect(page).to have_text I18n.t("missions.destroy.success")
    expect(page).to have_current_path root_path
    expect(page).to have_css(".mission", count: 4)
  end

end
require "rails_helper"

RSpec.feature "mission", type: :feature do
  before do
    create_list(:mission, 2, :waiting)
    create_list(:mission, 2, :progressing)
    # page.driver.header 'Accept-Language', locale
    # I18n.locale = locale
  end
  let!(:mission) {create(:mission, :completed, name: "testing example")}
  # let(:locale) { :en }

  scenario "with mission list" do
    visit root_path
    expect(page).to have_current_path root_path
    expect(page).to have_link(I18n.t("missions.create_button"))
    expect(page).to have_css("#missions_table")
    expect(page).to have_content(I18n.t("missions.table.name"))
    expect(page).to have_content(I18n.t("missions.table.content"))
    expect(page).to have_button(I18n.t("missions.table.created_at"))
    expect(page).to have_button(I18n.t("missions.table.deadline"))
    expect(page).to have_button(I18n.t("missions.table.work_state"))
    expect(page).to have_field(I18n.t("missions.table.search.query"))
    expect(page).to have_select(I18n.t("missions.table.search.work_state"))
    expect(page).to have_css(".mission", count: 5)
    mission = all(".mission").first
    expect(mission).to have_css(".mission-name")
    expect(mission).to have_css(".mission-content")
    expect(mission).to have_css(".mission-created-at")
    expect(mission).to have_css(".mission-deadline")
    expect(mission).to have_css(".mission-work-state")
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
  end
  
  scenario "with sorting button in mission list" do
    visit root_path
    expect(page).to have_button(I18n.t("missions.table.created_at"))
    expect(page).to have_button(I18n.t("missions.table.deadline"))
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
    # click_button I18n.t("missions.table.created_at")
    # all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    # expect(all_datetime[0]).to be > all_datetime[1]
    # click_button I18n.t("missions.table.created_at")
    # all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    # expect(all_datetime[0]).to be < all_datetime[1]
    # click_button I18n.t("missions.table.deadline")
    # all_datetime = all(".mission-deadline").map(&:text).map(&:to_datetime)
    # expect(all_datetime[0]).to be < all_datetime[1]
  end
  
  scenario "with searching bar" do
    visit root_path 
    expect(page).to have_field(I18n.t("missions.table.search.query"))
    expect(page).to have_select(I18n.t("missions.table.search.work_state"))
    fill_in I18n.t("missions.table.search.query"), with: "Testing"
    click_button I18n.t("missions.table.search.submit")
    expect(page).to have_content(mission.name)
    expect(page).to have_content(mission.content)
    expect(page).to have_content(mission.work_state)
    
    find("#search select").select("waiting")
    click_button I18n.t("missions.table.search.submit")
    expect(page).to have_css(".mission", count: 2)

    fill_in I18n.t("missions.table.search.query"), with: "Testing"
    find("#search select").select("completed")
    click_button I18n.t("missions.table.search.submit")
    expect(page).to have_content(mission.name)
    expect(page).to have_css(".mission", count: 1)
  end
  
  scenario "when viewing mission with deadline" do
    visit mission_path(mission.id)
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_content(mission.name)
    expect(page).to have_content(mission.content)
    expect(page).to have_content(mission.created_at.to_s(:short))
    expect(page).to have_content(mission.deadline.to_s)
    expect(page).to have_content(I18n.t("missions.table.state_type.#{mission.work_state}"))
    expect(page).to have_link(I18n.t("missions.edit_button"))
    expect(page).to have_link(I18n.t("missions.destroy_button"))
    expect(page).to have_link(I18n.t("missions.return_button"))
  end
  scenario "when viewing mission without deadline" do
    mission = create(:mission, deadline: nil)
    visit mission_path(mission.id)
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_content(mission.name)
    expect(page).to have_content(mission.content)
    expect(page).to have_content(mission.created_at.to_s(:short))
    expect(page).to have_content(I18n.t("missions.table.state_type.#{mission.work_state}"))
    expect(page).to have_content(I18n.t("missions.table.no_deadline"))
    expect(page).to have_link(I18n.t("missions.edit_button"))
    expect(page).to have_link(I18n.t("missions.destroy_button"))
    expect(page).to have_link(I18n.t("missions.return_button"))
  end
  
  scenario "when creating new mission with deadline" do
    visit new_mission_path
    expect(page).to have_current_path new_mission_path
    fill_in "mission_name", with: "Testing Mission name"
    fill_in "mission_content", with: "Testing Mission Content"
    find("#deadline_year").select '2020'
    find("#deadline_month").select 'March'
    find("#deadline_day").select '8'
    click_button I18n.t("missions.table.create")
    expect(page).to have_current_path root_path
    expect(page).to have_text I18n.t("missions.create.success")
    expect(page).to have_content "Testing Mission name"
    expect(page).to have_content "Testing Mission Content"
    expect(page).to have_content "2020-03-08"
    expect(page).to have_css(".mission", count: 6)
  end

  scenario "when creating new mission without deadline" do
    visit new_mission_path
    expect(page).to have_current_path new_mission_path
    fill_in "mission_name", with: "Testing Mission name"
    fill_in "mission_content", with: "Testing Mission Content"
    find("#no_deadline").click
    click_button I18n.t("missions.table.create")
    expect(page).to have_current_path root_path
    expect(page).to have_text I18n.t("missions.create.success")
    expect(page).to have_content "Testing Mission name"
    expect(page).to have_content "Testing Mission Content"
    expect(page).to have_content I18n.t("missions.table.no_deadline")
    expect(page).to have_css(".mission", count: 6)
  end
  
  scenario "when updating mission with deadline" do
    visit edit_mission_path(mission.id)
    expect(page).to have_current_path edit_mission_path(mission.id)
    fill_in "mission_name", with: "Updated Mission name"
    fill_in "mission_content", with: "Updated Mission Content"
    find("#deadline_year").select '2021'
    find("#deadline_month").select 'March'
    find("#deadline_day").select '9'
    click_button I18n.t("missions.table.update")
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_text I18n.t("missions.update.success")
    expect(page).to have_content "Updated Mission name"
    expect(page).to have_content "Updated Mission Content"
    expect(page).to have_content "2021-03-09"
  end

  scenario "when updating mission without deadline" do
    visit edit_mission_path(mission.id)
    expect(page).to have_current_path edit_mission_path(mission.id)
    fill_in "mission_name", with: "Updated Mission name"
    fill_in "mission_content", with: "Updated Mission Content"
    find("#no_deadline").click
    click_button I18n.t("missions.table.update")
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_text I18n.t("missions.update.success")
    expect(page).to have_content "Updated Mission name"
    expect(page).to have_content "Updated Mission Content"
    expect(page).to have_content I18n.t("missions.table.no_deadline")
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
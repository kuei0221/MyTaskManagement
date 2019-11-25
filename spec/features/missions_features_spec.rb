require "rails_helper"

RSpec.feature "mission", type: :feature do
  let!(:user) { create(:user) }
  let!(:mission) {create(:mission, :completed, :low_priority, name: "testing example", user: user)}
  before do
    create_list(:mission, 2, :waiting, :medium_priority, user: user)
    create_list(:mission, 2, :progressing, :high_priority, user: user)  
    other_user = create(:user)
    create_list(:mission, 1, :waiting, :medium_priority, user: other_user)
    create_list(:mission, 3, :progressing, :high_priority, user: other_user)
    create_list(:mission, 5, :completed, :low_priority, user: other_user)
    # page.driver.header 'Accept-Language', locale
    # I18n.locale = locale
  end
  # let(:locale) { :en }

  scenario "login" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
  end
  scenario "with mission list" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path

    visit root_path
    expect(page).to have_current_path root_path
    expect(page).to have_link(I18n.t("missions.create_button"))
    expect(page).to have_css("#missions_table")
    expect(page).to have_content(I18n.t("missions.table.name"))
    expect(page).to have_content(I18n.t("missions.table.content"))
    expect(page).to have_link(I18n.t("missions.table.created_at"))
    expect(page).to have_link(I18n.t("missions.table.deadline"))
    expect(page).to have_link(I18n.t("missions.table.work_state"))
    expect(page).to have_link(I18n.t("missions.table.priority"))
    expect(page).to have_field(I18n.t("missions.table.search.name"))
    expect(page).to have_select(I18n.t("missions.table.search.work_state"))
    expect(page).to have_select(I18n.t("missions.table.search.priority"))
    expect(page).to have_css(".mission", count: 5)
    mission = all(".mission").first
    expect(mission).to have_css(".mission-name")
    expect(mission).to have_css(".mission-content")
    expect(mission).to have_css(".mission-created-at")
    expect(mission).to have_css(".mission-deadline")
    expect(mission).to have_css(".mission-work-state")
    expect(mission).to have_css(".mission-priority")
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
  end
  
  scenario "with sorting button in mission list" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit root_path
    expect(page).to have_link(I18n.t("missions.table.created_at"))
    expect(page).to have_link(I18n.t("missions.table.deadline"))
    expect(page).to have_link(I18n.t("missions.table.work_state"))
    expect(page).to have_link(I18n.t("missions.table.priority"))
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]

    # All sort button default direction is "asc", and if no sorting, data is sort by created time in asc
    # So to desc at created need to press twice
    click_link I18n.t("missions.table.created_at")
    click_link I18n.t("missions.table.created_at")
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be > all_datetime[1]
    click_link I18n.t("missions.table.created_at")
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
    
    click_link I18n.t("missions.table.deadline")
    all_datetime = all(".mission-deadline").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
    click_link I18n.t("missions.table.deadline")
    all_datetime = all(".mission-deadline").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be > all_datetime[1]
    click_link I18n.t("missions.table.deadline")
    all_datetime = all(".mission-deadline").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
    
    click_link I18n.t("missions.table.work_state")
    all_state = all(".mission-work-state").map(&:text)
    expect(all_state[0]).to eq I18n.t(".missions.table.state_type.waiting")
    expect(all_state[4]).to eq I18n.t(".missions.table.state_type.completed")
    click_link I18n.t("missions.table.work_state")
    all_state = all(".mission-work-state").map(&:text)
    expect(all_state[4]).to eq I18n.t(".missions.table.state_type.waiting")
    expect(all_state[0]).to eq I18n.t(".missions.table.state_type.completed")
    click_link I18n.t("missions.table.work_state")
    all_state = all(".mission-work-state").map(&:text)
    expect(all_state[0]).to eq I18n.t(".missions.table.state_type.waiting")
    expect(all_state[4]).to eq I18n.t(".missions.table.state_type.completed")
    
    click_link I18n.t("missions.table.priority")
    all_priority = all(".mission-priority").map(&:text)
    expect(all_priority[0]).to eq I18n.t(".missions.table.priority_level.low")
    expect(all_priority[4]).to eq I18n.t(".missions.table.priority_level.high")
    click_link I18n.t("missions.table.priority")
    all_priority = all(".mission-priority").map(&:text)
    expect(all_priority[4]).to eq I18n.t(".missions.table.priority_level.low")
    expect(all_priority[0]).to eq I18n.t(".missions.table.priority_level.high")
    click_link I18n.t("missions.table.priority")
    all_priority = all(".mission-priority").map(&:text)
    expect(all_priority[0]).to eq I18n.t(".missions.table.priority_level.low")
    expect(all_priority[4]).to eq I18n.t(".missions.table.priority_level.high")

  end
  
  scenario "with searching bar" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit root_path 
    expect(page).to have_field(I18n.t("missions.table.search.name"))
    expect(page).to have_select(I18n.t("missions.table.search.work_state"))
    fill_in I18n.t("missions.table.search.name"), with: "Testing"
    click_button I18n.t("missions.table.search.submit")
    expect(page).to have_content(mission.name)
    expect(page).to have_content(mission.content)
    expect(page).to have_content(I18n.t("missions.table.state_type.#{mission.work_state}"))
    
    find("select#work_state").select(I18n.t("missions.table.state_type.waiting"))
    click_button I18n.t("missions.table.search.submit")
    expect(page).to have_css(".mission", count: 2)

    find("select#priority").select(I18n.t("missions.table.priority_level.low"))
    click_button I18n.t("missions.table.search.submit")
    expect(page).to have_css(".mission", count: 1)
    
    fill_in I18n.t("missions.table.search.name"), with: "Testing"
    find("select#work_state").select(I18n.t("missions.table.state_type.completed"))
    find("select#priority").select(I18n.t("missions.table.priority_level.low"))
    click_button I18n.t("missions.table.search.submit")
    expect(page).to have_content(mission.name)
    expect(page).to have_css(".mission", count: 1)
  end
  
  scenario "filter button" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path

    visit root_path
    click_link I18n.t("missions.table.state_type.waiting")
    all_state = all(".mission-work-state").map(&:text)
    expect(all_state.all? I18n.t("missions.table.state_type.waiting")).to be true
    click_link I18n.t("missions.table.state_type.progressing")
    all_state = all(".mission-work-state").map(&:text)
    expect(all_state.all? I18n.t("missions.table.state_type.progressing")).to be true
    click_link I18n.t("missions.table.state_type.completed")
    all_state = all(".mission-work-state").map(&:text)
    expect(all_state.all? I18n.t("missions.table.state_type.completed")).to be true
    
    click_link I18n.t("missions.table.priority_level.low")
    all_priority = all(".mission-priority").map(&:text)
    expect(all_priority.all? I18n.t("missions.table.priority_level.low")).to be true 
    click_link I18n.t("missions.table.priority_level.medium")
    all_priority = all(".mission-priority").map(&:text)
    expect(all_priority.all? I18n.t("missions.table.priority_level.medium")).to be true 
    click_link I18n.t("missions.table.priority_level.high")
    all_priority = all(".mission-priority").map(&:text)
    expect(all_priority.all? I18n.t("missions.table.priority_level.high")).to be true 
  end
  
  scenario "filter and sort button" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit root_path
    click_link I18n.t("missions.table.state_type.waiting")
    all_state = all(".mission-work-state").map(&:text)
    expect(all_state.all? I18n.t("missions.table.state_type.waiting")).to be true 
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
    click_link I18n.t("missions.table.created_at")
    click_link I18n.t("missions.table.created_at")
    expect(page).to have_css(".mission", count: 2)
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be > all_datetime[1]
    all_state = all(".mission-work-state").map(&:text)
    expect(all_state.all? I18n.t("missions.table.state_type.waiting") ).to be true
  end
  
  scenario "search and sort" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit root_path
    find("select#work_state").select(I18n.t("missions.table.state_type.waiting"))
    click_button I18n.t("missions.table.search.submit")
    expect(page).to have_css(".mission", count: 2)
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]

    click_link I18n.t("missions.table.created_at")
    click_link I18n.t("missions.table.created_at")
    expect(page).to have_css(".mission", count: 2)
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be > all_datetime[1]
    click_link I18n.t("missions.table.created_at")
    expect(page).to have_css(".mission", count: 2)
    all_datetime = all(".mission-created-at").map(&:text).map(&:to_datetime)
    expect(all_datetime[0]).to be < all_datetime[1]
  end
  
  scenario "when viewing mission with deadline" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit mission_path(mission.id)
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_content(mission.name)
    expect(page).to have_content(mission.content)
    expect(page).to have_content(mission.created_at.strftime("%Y-%m-%d"))
    expect(page).to have_content(mission.deadline.to_s)
    expect(page).to have_content(I18n.t("missions.table.priority_level.#{mission.priority}"))
    expect(page).to have_content(I18n.t("missions.table.state_type.#{mission.work_state}"))
    expect(page).to have_link(I18n.t("missions.edit_button"))
    expect(page).to have_link(I18n.t("missions.destroy_button"))
    expect(page).to have_link(I18n.t("missions.return_button"))
  end
  scenario "when viewing mission without deadline" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    mission = create(:mission, deadline: nil, user: user)
    visit mission_path(mission.id)
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_content(mission.name)
    expect(page).to have_content(mission.content)
    expect(page).to have_content(mission.created_at.strftime("%Y-%m-%d"))
    expect(page).to have_content(I18n.t("missions.table.priority_level.#{mission.priority}"))
    expect(page).to have_content(I18n.t("missions.table.state_type.#{mission.work_state}"))
    expect(page).to have_content(I18n.t("missions.table.no_deadline"))
    expect(page).to have_link(I18n.t("missions.edit_button"))
    expect(page).to have_link(I18n.t("missions.destroy_button"))
    expect(page).to have_link(I18n.t("missions.return_button"))
  end
  
  scenario "when creating new mission with deadline" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit new_mission_path
    expect(page).to have_current_path new_mission_path
    fill_in "mission_name", with: "Testing Mission name"
    fill_in "mission_content", with: "Testing Mission Content"
    find("#deadline_year").select '2020'
    find("#deadline_month").select 'March'
    find("#deadline_day").select '8'
    find("#mission_priority").select I18n.t("missions.table.priority_level.low")
    find("#mission_priority").select I18n.t("missions.table.priority_level.medium")
    find("#mission_priority").select I18n.t("missions.table.priority_level.high")
    click_button I18n.t("missions.table.create")
    expect(page).to have_current_path root_path
    expect(page).to have_text I18n.t("missions.create.success")
    expect(page).to have_content "Testing Mission name"
    expect(page).to have_content "Testing Mission Content"
    expect(page).to have_content "2020-03-08"
    expect(page).to have_css(".mission", count: 6)
  end
  
  scenario "when creating new mission without deadline" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit new_mission_path
    expect(page).to have_current_path new_mission_path
    fill_in "mission_name", with: "Testing Mission name"
    fill_in "mission_content", with: "Testing Mission Content"
    find("#no_deadline").click
    find("#mission_priority").select I18n.t("missions.table.priority_level.high")
    find("#mission_priority").select I18n.t("missions.table.priority_level.medium")
    find("#mission_priority").select I18n.t("missions.table.priority_level.low")
    click_button I18n.t("missions.table.create")
    expect(page).to have_current_path root_path
    expect(page).to have_text I18n.t("missions.create.success")
    expect(page).to have_content "Testing Mission name"
    expect(page).to have_content "Testing Mission Content"
    expect(page).to have_content I18n.t("missions.table.no_deadline")
    expect(page).to have_css(".mission", count: 6)
  end
  
  scenario "when updating mission with deadline" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit edit_mission_path(mission.id)
    expect(page).to have_current_path edit_mission_path(mission.id)
    fill_in "mission_name", with: "Updated Mission name"
    fill_in "mission_content", with: "Updated Mission Content"
    find("#deadline_year").select '2021'
    find("#deadline_month").select 'March'
    find("#deadline_day").select '9'
    find("#mission_priority").select I18n.t("missions.table.priority_level.medium")
    click_button I18n.t("missions.table.update")
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_text I18n.t("missions.update.success")
    expect(page).to have_content "Updated Mission name"
    expect(page).to have_content "Updated Mission Content"
    expect(page).to have_content "2021-03-09"
    expect(page).to have_content I18n.t("missions.table.priority_level.medium")
  end
  
  scenario "when updating mission without deadline" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit edit_mission_path(mission.id)
    expect(page).to have_current_path edit_mission_path(mission.id)
    fill_in "mission_name", with: "Updated Mission name"
    fill_in "mission_content", with: "Updated Mission Content"
    find("#no_deadline").click
    find("#mission_priority").select I18n.t("missions.table.priority_level.high")
    click_button I18n.t("missions.table.update")
    expect(page).to have_current_path mission_path(mission.id)
    expect(page).to have_text I18n.t("missions.update.success")
    expect(page).to have_content "Updated Mission name"
    expect(page).to have_content "Updated Mission Content"
    expect(page).to have_content I18n.t("missions.table.no_deadline")
    expect(page).to have_content I18n.t("missions.table.priority_level.high")
  end
  
  scenario "when deleting mission" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    visit mission_path(mission.id)
    expect(page).to have_link(I18n.t("missions.destroy_button"))
    click_link I18n.t("missions.destroy_button")
    expect(page).to have_text I18n.t("missions.destroy.success")
    expect(page).to have_current_path root_path
    expect(page).to have_css(".mission", count: 4)
  end

  scenario "header: when admin user in normal role" do
    user = create(:user, :admin)
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    expect(page).to have_css "#role_dropdown"
    expect(page).not_to have_css "#backstage_entrance"
    
  end
  scenario "header: when admin user in administrator role " do
    user = create(:user, :admin, :administrator)
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    expect(page).to have_css "#role_dropdown"
    expect(page).to have_css "#backstage_entrance"
  end

  scenario "header: when normal user" do
    user = create(:user)
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    expect(page).not_to have_css "#role_dropdown"
    expect(page).not_to have_css "#backstage_entrance"
    
  end

end
require "rails_helper"

RSpec.feature "sessions", type: :feature do
  let!(:user) { create(:user) }

  scenario "login with exist account" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
  end

  scenario "login with invalid input" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.alert")
  end

  scenario "login when already login" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    
    visit login_path
    expect(page).to have_content I18n.t("sessions.only_not_login.alert")
    expect(page).to have_current_path root_path
  end

  scenario "logout" do
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")
    expect(page).to have_content I18n.t("sessions.create.success")
    expect(page).to have_current_path root_path
    expect(page).to have_link I18n.t("views.header.logout")
    click_link I18n.t("views.header.logout")
    expect(page).to have_content I18n.t("sessions.destroy.success")
    expect(page).to have_link I18n.t("views.header.login")
  end

  scenario "logout when not login" do
    visit logout_path
    expect(page).to have_content I18n.t("sessions.only_login.alert")
    expect(page).to have_current_path login_path
  end

end
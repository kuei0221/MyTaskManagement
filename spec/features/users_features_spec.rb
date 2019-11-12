require "rails_helper"

RSpec.feature "users", type: :feature do
  scenario "sign up as new user" do
    visit new_user_path
    expect(page).to have_current_path new_user_path
    fill_in I18n.t("users.new.name"), with: "New User"
    fill_in I18n.t("users.new.email"), with: "New_user@email.com"
    fill_in I18n.t("users.new.password"), with: "password"
    fill_in I18n.t("users.new.password_confirmation"), with: "password"
    click_button I18n.t("users.new.submit")
    expect(page).to have_current_path root_path
    expect(page).to have_content I18n.t("users.create.success")
  end

  scenario "sign up with invalid input" do
    visit new_user_path
    expect(page).to have_current_path new_user_path

    fill_in I18n.t("users.new.name"), with: "New User"
    click_button I18n.t("users.new.submit")
    expect(page).to have_content I18n.t("users.create.alert")

    fill_in I18n.t("users.new.email"), with: "New_user@email.com"
    click_button I18n.t("users.new.submit")
    expect(page).to have_content I18n.t("users.create.alert")

    fill_in I18n.t("users.new.password"), with: "password"
    click_button I18n.t("users.new.submit")
    expect(page).to have_content I18n.t("users.create.alert")

    fill_in I18n.t("users.new.password_confirmation"), with: "password"
    click_button I18n.t("users.new.submit")
    expect(page).to have_content I18n.t("users.create.alert")
  end

  scenario "sign up when already login" do
    user = create(:user)
    visit login_path
    fill_in I18n.t("sessions.new.email"), with: user.email
    fill_in I18n.t("sessions.new.password"), with: user.password
    click_button I18n.t("sessions.new.submit")

    visit new_user_path
    expect(page).to have_content I18n.t("sessions.only_not_login.alert")
    expect(page).to have_current_path root_path
  end
end
require "factory_bot_rails"

i = 0
while true do
  user = FactoryBot.create(:user)
  missions = Mission.where(user_id: nil).page(i)
  if missions.present?
    missions.update_all(user_id: user.id)
    i += 1
  else
    break
  end
end

10.times do
  FactoryBot.create(:user_with_missions, missions_count: rand(1..100))
end

user = FactoryBot.create(:user_with_missions, email: "testing@email.com", missions_count: 50, name: "testing_user")
user = FactoryBot.create(:user_with_missions, :admin ,email: "admin_testing@email.com", missions_count: 50, name: "admin_testing_user")

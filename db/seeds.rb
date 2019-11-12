require "factory_bot_rails"

i = 0
while true, i=0 do
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

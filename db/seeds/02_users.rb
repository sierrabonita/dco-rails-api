puts "--- 02_users.rb を実行中 ---"

User.destroy_all

users_data = [
  { name: "山田太郎", email: "test_1@test.com", password: "Password0_" },
  { name: "田中花子", email: "test_2@test.com", password: "Password0_" }
]

users_data.each { |data| User.create!(data) }

puts "--- 02_users.rb が完了しました ---"

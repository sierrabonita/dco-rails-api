puts "=== Usersの初期化を開始します ==="

User.destroy_all

users = [{ name: "山田太郎", email: "test_1@test.com", password: "P@ssword1" }]

users.each { |user_param| User.create!(user_param) }

puts "=== Usersの初期化が完了しました ==="
